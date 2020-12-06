// MIT License
//
// Copyright (c) 2020 Igor Tiukavkin.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

public class List: View {

    private let selection: ActionWith<IndexPath>?
    private let viewsBinding: Binding<[View]>

    public init<Item>(_ data: Binding<[Item]>, selection: ActionWith<Item>? = nil, rowContent: @escaping (Item) -> View) {
        self.selection = selection?.map { data.value[$0.row] }
        self.viewsBinding = data.map { $0.map(rowContent) }
        super.init()
    }

    public convenience init<Item>(_ data: [Item], selection: ActionWith<Item>? = nil, rowContent: @escaping (Item) -> View) {
        self.init(.constant(data), selection: selection, rowContent: rowContent)
    }

    public init(selection: ActionWith<IndexPath>? = nil, rows: () -> [View]) {
        self.selection = selection
        self.viewsBinding = .constant(rows())
        super.init()
    }

    override var toUIView: UIView {
        return ListTableView(views: self.viewsBinding, selection: self.selection)
    }

    override func addChild(child: View, to selfView: UIView) {}
}

internal class ListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, KeyboardBindable {

    var extraOffset: CGFloat = 0.0
    var defaultInsets: UIEdgeInsets = .zero
    let views: Binding<[View]>
    let selection: ActionWith<IndexPath>
    weak var customDelegate: UIScrollViewDelegate?

    init(views: Binding<[View]>, selection: ActionWith<IndexPath>?) {
        self.views = views
        self.selection = selection ?? .empty
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .clear
        self.tableFooterView = UIView()
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableView.automaticDimension
        self.allowsMultipleSelection = false
        self.allowsSelection = selection != nil

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true

        self.views.bind(ActionWith<[View]> { [weak self] _ in
            self?.reloadData()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.views.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.contentView.addSubview(self.views.value[indexPath.row].display(), insets: .zero)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selection.execute(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view = self.views.value[indexPath.row]
        return view is Divider ? Divider.height : UITableView.automaticDimension
    }
}

extension ListTableView: Delegateable {

    func setDelegate(delegate: Any) {
        self.customDelegate = delegate as? UIScrollViewDelegate
    }
}

extension ListTableView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.customDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.customDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return self.customDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        self.customDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}

public extension List {

    func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        return self.add(modifier: SeparatorStyle(separatorStyle: separatorStyle))
    }

    func separatorColor(_ color: Color) -> Self {
        return self.add(modifier: SeparatorColor(color: color))
    }

    func separatorInset(_ inset: UIEdgeInsets) -> Self {
        return self.add(modifier: SeparatorInset(separatorInset: inset))
    }

    func scrollEnabled(_ enabled: Bool) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: .constant(enabled)))
    }

    func scrollEnabled(_ enabled: Binding<Bool>) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: enabled))
    }

    func bindToKeyboard(extraOffset: CGFloat = 0.0) -> Self {
        return self.add(modifier: BindToKeyboard(extraOffset: extraOffset))
    }

    func beginEndUpdates(_ createAction: @escaping (Action) -> ()) -> Self {
        let modifier = ActionCreator(action: ActionWith<UITableView> { view in
            let action = Action { [weak view] in
                view?.beginUpdates()
                view?.endUpdates()
            }
            createAction(action)
        })
        return self.add(modifier: modifier)
    }

    func reloadData(_ createAction: @escaping (Action) -> ()) -> Self {
        let modifier = ActionCreator(action: ActionWith<UITableView> { view in
            let action = Action { [weak view] in
                view?.reloadData()
            }
            createAction(action)
        })
        return self.add(modifier: modifier)
    }

    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return self.add(modifier: Delegate(delegate: delegate))
    }
}
