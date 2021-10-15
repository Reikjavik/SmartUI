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
    private let sectionsBinding: Binding<[Section]>

    public init<Item>(_ data: Binding<[Item]>, selection: ((Item) -> Void)? = nil, rowContent: @escaping (Item) -> View) {
        let selectionAction = ActionWith<Item>(selection)
        self.selection = selectionAction?.compactMap { data.value?[$0.row] }
        self.sectionsBinding = data.map { items in [Section(rows: { items.map(rowContent) })] }
        super.init()
    }

    public convenience init<Item>(_ data: [Item], selection: ((Item) -> Void)? = nil, rowContent: @escaping (Item) -> View) {
        self.init(.create(data), selection: selection, rowContent: rowContent)
    }

    public init(selection: ((IndexPath) -> Void)? = nil, rows: () -> [View]) {
        let selectionAction = ActionWith<IndexPath>(selection)
        self.selection = selectionAction
        self.sectionsBinding = .create([Section(rows: rows)])
        super.init()
    }

    public init(selection: ((IndexPath) -> Void)? = nil, sections: Binding<[Section]>) {
        let selectionAction = ActionWith<IndexPath>(selection)
        self.selection = selectionAction
        self.sectionsBinding = sections
        super.init()
    }

    public convenience init(selection: ((IndexPath) -> Void)? = nil, sections: () -> [Section]) {
        self.init(selection: selection, sections: .create(sections()))
    }

    override var toUIView: UIView {
        let style = self.modifiers.compactMap { $0 as? ListStyleModifier }.last
        return ListTableView(sections: self.sectionsBinding, selection: self.selection, style: style?.style.style ?? .plain)
    }

    override func addChild(child: View) {}
}

public class Section {

    let header: View?
    let rows: [View]
    let footer: View?

    public init(header: View? = nil, footer: View? = nil, rows: () -> [View]) {
        self.header = header
        self.footer = footer
        self.rows = rows()
    }
}

internal class ListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, KeyboardBindable {

    var observer = KeyboardHeightObserver()
    let sections: Binding<[Section]>
    let selection: ActionWith<IndexPath>
    weak var customDelegate: UIScrollViewDelegate?

    init(sections: Binding<[Section]>, selection: ActionWith<IndexPath>?, style: UITableView.Style) {
        self.sections = sections
        self.selection = selection ?? .empty
        super.init(frame: .zero, style: style)
        self.backgroundColor = .clear
        let headerFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        self.tableHeaderView = headerFooterView
        self.tableFooterView = headerFooterView
        self.delegate = self
        self.dataSource = self
        self.rowHeight = UITableView.automaticDimension
        self.allowsMultipleSelection = false
        self.allowsSelection = selection != nil

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true

        self.sections.bind(ActionWith<[Section]> { [weak self] _ in
            self?.reloadData()
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.value?[section].rows.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        (self.sections.value?[indexPath.section].rows[indexPath.row].display()).map {
            cell.contentView.addSubview($0, insets: .zero)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selection.execute(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let view = self.sections.value?[indexPath.section].rows[indexPath.row]
        return view is Divider ? Divider.height : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections.value?[section].header?.display()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sections.value?[section].footer?.display()
    }

    func tableView(_ tableView:  UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sections.value?[section].header != nil {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.sections.value?[section].footer != nil {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
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
        return self.add(modifier: ScrollEnabled(isScrollEnabled: .create(enabled)))
    }

    func scrollEnabled(_ enabled: Binding<Bool>) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: enabled))
    }

    func bindToKeyboard(extraOffset: CGFloat = 0.0) -> Self {
        return self.add(modifier: BindToKeyboard(extraOffset: extraOffset))
    }

    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return self.add(modifier: Delegate(delegate: delegate))
    }

    func listStyle(_ style: ListStyle) -> Self {
        return self.add(modifier: ListStyleModifier(style: style))
    }
}
