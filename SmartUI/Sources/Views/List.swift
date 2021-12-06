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
    private let sections: Binding<[Section]>

    public init<Item: Identifiable>(_ data: Binding<[Item]>, selection: ((Item) -> Void)? = nil, rowContent: @escaping (Item) -> View) {
        let selectionAction = ActionWith<Item>(selection)
        let section = Section(data: data, content: rowContent)
        self.selection = selectionAction?.compactMap { data.value?[$0.row] }
        self.sections = .create([section])
        super.init()
    }

    public convenience init<Item: Identifiable>(_ data: [Item], selection: ((Item) -> Void)? = nil, rowContent: @escaping (Item) -> View) {
        self.init(.create(data), selection: selection, rowContent: rowContent)
    }

    public init(selection: ((IndexPath) -> Void)? = nil, content: () -> [View]) {
        let selectionAction = ActionWith<IndexPath>(selection)
        self.selection = selectionAction
        self.sections = .create([Section(content: content)])
        super.init()
    }

    public init(selection: ((IndexPath) -> Void)? = nil, sections: Binding<[Section]>) {
        let selectionAction = ActionWith<IndexPath>(selection)
        self.selection = selectionAction
        self.sections = sections
        super.init()
    }

    public convenience init(selection: ((IndexPath) -> Void)? = nil, sections: () -> [Section]) {
        self.init(selection: selection, sections: .create(sections()))
    }

    override var toUIView: UIView {
        let style = self.modifiers.compactMap { $0 as? ListStyleModifier }.last
        let rowAnimation = self.modifiers.compactMap { $0 as? RowAnimation }.last
        return ListTableView(
            sections: self.sections,
            rowAnimation: rowAnimation?.rowAnimation,
            selection: self.selection,
            style: style?.style.style ?? .plain
        )
    }
}

public protocol Identifiable {
    var id: String { get }
}

struct EID: Identifiable, Hashable {
    let id: String
}

public class Section: Identifiable, Equatable {

    public let id: String
    public let header: View?
    public let footer: View?
    public let items: Binding<[Identifiable]>
    public let content: ((Identifiable) -> View?)

    public static func == (lhs: Section, rhs: Section) -> Bool {
        return lhs.id == rhs.id
    }

    public init<Item: Identifiable>(id: String? = nil, data: Binding<[Item]>, header: View? = nil, footer: View? = nil, content: @escaping (Item) -> View) {
        let dataBinding = data.map { (items) -> [Item] in
            let uniqueItems = items.distinct()
            if items.count != uniqueItems.count {
                print("⚠️ SmartUI: There are duplicates in the items array provided for Section update. Be careful, this may cause problems. Only unique items will be displayed.")
            }
            return uniqueItems
        }
        // Used for diffable items binding
        self.items = dataBinding.map { $0 as [Identifiable] }
        self.content = { ($0 as? Item).map(content) }
        self.header = header
        self.footer = footer
        self.id = id ?? UUID().uuidString
    }

    public convenience init<Item: Identifiable>(id: String? = nil, data: [Item], header: View? = nil, footer: View? = nil, content: @escaping (Item) -> View) {
        self.init(id: id, data: .create(data), header: header, footer: footer, content: content)
    }

    public convenience init(id: String? = nil, header: View? = nil, footer: View? = nil, content: () -> [View]) {
        let views = content()
        let ids = views.map { _ in EID(id: UUID().uuidString) }
        self.init(id: id, data: ids, header: header, footer: footer) { id in
            ids.firstIndex(of: id).map { views[$0] } ?? .empty
        }
    }
}

internal class ListTableView: UITableView, UITableViewDelegate, UITableViewDataSource, KeyboardBindable, DiffableCollection {

    var observer = KeyboardHeightObserver()
    let sectionsBinding: Binding<[Section]>?
    let selection: ActionWith<IndexPath>
    let rowAnimation: Binding<UITableView.RowAnimation>?

    var sections: [Section] = []
    var items: [String: [Identifiable]] = [:]

    var updatesDisposeBag: [AnyCancellable] = []
    weak var customDelegate: UIScrollViewDelegate?

    init(sections: Binding<[Section]>,
         rowAnimation: Binding<UITableView.RowAnimation>?,
         selection: ActionWith<IndexPath>?,
         style: UITableView.Style) {
        self.sectionsBinding = sections
        self.selection = selection ?? .empty
        self.rowAnimation = rowAnimation
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
        self.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true

        self.sectionsBinding?.bind(ActionWith<[Section]> { [weak self] sections in
            self?.reload(sections: sections)
        }).store(in: &disposeBag)

        self.reload(sections: sections.value ?? [])
    }

    func updateSections(inserted: IndexSet, deleted: IndexSet, common: IndexSet) {
        let rowAnimation = self.rowAnimation?.value ?? .automatic
        self.beginUpdates()
        self.deleteSections(deleted, with: rowAnimation)
        self.insertSections(inserted, with: rowAnimation)
        self.reloadSections(common, with: rowAnimation)
        self.endUpdates()
    }

    func updateItems(inserted: [IndexPath], deleted: [IndexPath]) {
        let rowAnimation = self.rowAnimation?.value ?? .automatic
        self.beginUpdates()
        self.deleteRows(at: deleted, with: rowAnimation)
        self.insertRows(at: inserted, with: rowAnimation)
        self.endUpdates()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionId = self.sections[safe: section]?.id else { return 0 }
        return self.items[sectionId]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear

        if let cell = cell as? ListTableViewCell {

            if let sectionId = self.sections[safe: indexPath.section]?.id,
               let item = self.items[sectionId]?[safe: indexPath.row] {
                if item.id != cell.itemId {
                    let view = self.sections[indexPath.section].content(item)
                    let selectionStyle = view?.modifiers.compactMap { $0 as? SelectionStyle }.last
                    let accessibility = view?.allAccessibilityModifiers ?? []
                    self.applySelectionStyle(cell: cell, style: selectionStyle)
                    self.applyAccessibility(cell: cell, modifiers: accessibility)
                    cell.configure(view: view)
                }
                cell.itemId = item.id
            }
        }

        return cell
    }

    private func applySelectionStyle(cell: UITableViewCell, style: SelectionStyle?) {
        if let color = style?.color {
            cell.selectionStyle = .default
            let view = UIView()
            view.backgroundColor = color.color
            cell.selectedBackgroundView = view
        } else {
            cell.selectionStyle = style?.style ?? .default
        }
    }

    private func applyAccessibility(cell: UITableViewCell, modifiers: [Modifier]) {
        cell.resetAccessibilityFields()
        modifiers.forEach {
            _ = $0.modify(cell)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selection.execute(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sections[section].header?.display()
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.sections[section].footer?.display()
    }

    func tableView(_ tableView:  UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sections[section].header != nil {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.sections[section].footer != nil {
            return UITableView.automaticDimension
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
}

final class ListTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: ListTableViewCell.self)
    var itemId: String?
    var view: UIView?
    var colorsCache: [UIView: UIColor] = [:]

    func configure(view: View?) {
        self.contentView.removeAllSubviews()
        view.map {
            let uiView = $0.display()
            self.contentView.addSubview(uiView, insets: .zero)
            self.view = uiView
        }
        self.cacheBackgroundColors()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.handleBackgroundsSwitch(highlighted: selected)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        self.handleBackgroundsSwitch(highlighted: highlighted)
    }

    private func handleBackgroundsSwitch(highlighted: Bool) {
        let allViews: [UIView] = self.view?.find() ?? []
        allViews.forEach { $0.backgroundColor = highlighted ? .clear : self.colorsCache[$0] }
    }

    private func cacheBackgroundColors() {
        self.colorsCache = [:]
        let allViews: [UIView] = self.view?.find() ?? []
        allViews.forEach { self.colorsCache[$0] = $0.backgroundColor }
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

    func rowAnimation(_ animation: UITableView.RowAnimation) -> Self {
        return self.add(modifier: RowAnimation(rowAnimation: .create(animation)))
    }

    func rowAnimation(_ animation: Binding<UITableView.RowAnimation>) -> Self {
        return self.add(modifier: RowAnimation(rowAnimation: animation))
    }

    func estimatedRowHeight(_ value: CGFloat) -> Self {
        return self.customModifier { view in
            let tableView = view as? UITableView
            tableView?.estimatedRowHeight = value
            return view
        }
    }
}
