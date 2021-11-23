// MIT License
//
// Copyright (c) 2021 Igor Tiukavkin.
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

public enum LazyItemsSize {
    case auto
    case manual((UICollectionView, IndexPath) -> CGSize)
}

public class LazyVGrid: View {

    private let itemsSize: LazyItemsSize
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat
    private let pinnedViews: PinnedScrollableViews
    private let selection: ActionWith<IndexPath>?
    private let itemsBinding: Binding<[AnyHashable]>?
    private let sectionsBinding: Binding<[Section]>?
    private let itemContent: ((AnyHashable) -> View?)?

    public init<Item: Hashable>(_ data: Binding<[Item]>, alignment: HorizontalAlignment = .center, spacing: CGFloat = UIView.defaultSpacing, itemsSize: LazyItemsSize = .auto, selection: ((Item) -> Void)? = nil, content: @escaping (Item) -> View) {
        let selectionAction = ActionWith<Item>(selection)
        let dataBinding = data.map { (items) -> [Item] in
            let uniqueItems = items.distinct()
            if items.count != uniqueItems.count {
                print("⚠️ SmartUI: There are duplicates in the items array provided for LazyVGrid update. Be careful, this may cause problems. Only unique items will be displayed.")
            }
            return uniqueItems
        }
        self.itemsSize = itemsSize
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = .init()
        self.selection = selectionAction?.compactMap { dataBinding.value?[$0.row] }
        self.itemContent = { ($0 as? Item).map(content) }
        self.itemsBinding = dataBinding.map { $0 as [AnyHashable] }
        self.sectionsBinding = nil
        super.init()
    }

    public convenience init(alignment: HorizontalAlignment = .center, spacing: CGFloat = UIView.defaultSpacing, itemsSize: LazyItemsSize = .auto, selection: ((IndexPath) -> Void)? = nil, content: Binding<[View]>) {
        self.init(sections: content.map { items in [Section(content: { items })] }, alignment: alignment, spacing: spacing, pinnedViews: .init(), itemsSize: itemsSize, selection: selection)
    }

    public convenience init(alignment: HorizontalAlignment = .center, spacing: CGFloat = UIView.defaultSpacing, itemsSize: LazyItemsSize = .auto, selection: ((IndexPath) -> Void)? = nil, content: @escaping () -> [View]) {
        self.init(sections: .create([Section(content: content)]), alignment: alignment, spacing: spacing, pinnedViews: .init(), itemsSize: itemsSize, selection: selection)
    }

    public convenience init(spacing: CGFloat = UIView.defaultSpacing, pinnedViews: PinnedScrollableViews = .init(), itemsSize: LazyItemsSize = .auto, selection: ((IndexPath) -> Void)? = nil, sections: @escaping () -> [Section]) {
        self.init(sections: Binding<[Section]>.create(sections()), alignment: .fill, spacing: spacing, pinnedViews: pinnedViews, itemsSize: itemsSize, selection: selection)
    }

    public convenience init(spacing: CGFloat = UIView.defaultSpacing, pinnedViews: PinnedScrollableViews = .init(), itemsSize: LazyItemsSize = .auto, selection: ((IndexPath) -> Void)? = nil, sections: Binding<[Section]>) {
        self.init(sections: sections, alignment: .fill, spacing: spacing, pinnedViews: pinnedViews, itemsSize: itemsSize, selection: selection)
    }

    internal init(sections: Binding<[Section]>, alignment: HorizontalAlignment, spacing: CGFloat, pinnedViews: PinnedScrollableViews, itemsSize: LazyItemsSize, selection: ((IndexPath) -> Void)?) {
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.selection = ActionWith(selection)
        self.sectionsBinding = sections
        self.itemsSize = itemsSize
        self.itemsBinding = nil
        self.itemContent = nil
        super.init()
    }

    override var toUIView: UIView {
        switch self.itemsSize {
        case .auto:
            return LazyVGridView(alignment: self.alignment, spacing: self.spacing, pinnedViews: self.pinnedViews, itemsSize: self.itemsSize, sectionsBinding: self.sectionsBinding, itemsBinding: self.itemsBinding, itemContent: self.itemContent, selection: self.selection)
        case .manual:
            return ManualSizedVGridView(alignment: self.alignment, spacing: self.spacing, pinnedViews: self.pinnedViews, itemsSize: self.itemsSize, sectionsBinding: self.sectionsBinding, itemsBinding: self.itemsBinding, itemContent: self.itemContent, selection: self.selection)
        }
    }

    override func view(view: UIView, didMoveTo parent: UIView) {
        guard parent is UIScrollView else { return }
        print("⚠️ SmartUI: LazyVGrid is already a CollectionView, please, do not wrap it with ScrollView, this may cause layout issues.")
    }
}

internal class LazyVGridView: UICollectionView, KeyboardBindable {

    var observer = KeyboardHeightObserver()
    let sectionsBinding: Binding<[Section]>?
    let itemsBinding: Binding<[AnyHashable]>?
    let itemContent: ((AnyHashable) -> View?)?
    let selection: ActionWith<IndexPath>?
    let itemsSize: LazyItemsSize

    private var sections: [Section]?
    private var items: [AnyHashable]?

    weak var customDelegate: UIScrollViewDelegate?

    init(alignment: HorizontalAlignment,
         spacing: CGFloat,
         pinnedViews: PinnedScrollableViews,
         itemsSize: LazyItemsSize,
         sectionsBinding: Binding<[Section]>?,
         itemsBinding: Binding<[AnyHashable]>?,
         itemContent: ((AnyHashable) -> View?)?,
         selection: ActionWith<IndexPath>?) {
        self.itemsSize = itemsSize
        self.itemsBinding = itemsBinding
        self.itemContent = itemContent
        self.selection = selection
        self.sectionsBinding = sectionsBinding
        self.sections = sectionsBinding?.value
        self.items = itemsBinding?.value
        let layout: UICollectionViewFlowLayout
        switch alignment {
        case .fill:
            layout = UICollectionViewFlowLayout()
        case .leading:
            layout = LeftAlignedLayout()
        case .center:
            layout = CenterAlignedLayout()
        case .trailing:
            layout = RightAlignedLayout()
        }
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .clear
        layout.sectionHeadersPinToVisibleBounds = pinnedViews.contains(.sectionHeaders)
        layout.sectionFootersPinToVisibleBounds = pinnedViews.contains(.sectionFooters)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        if case .auto = itemsSize {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        layout.sectionInset = UIEdgeInsets(top: spacing, bottom: spacing, left: 0.0, right: 0.0)

        self.delegate = self
        self.dataSource = self
        self.allowsMultipleSelection = false
        self.allowsSelection = selection != nil
        self.register(LazyGridCell.self, forCellWithReuseIdentifier: LazyGridCell.reuseIdentifier)
        self.register(LazyGridFooterHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LazyGridFooterHeader.reuseIdentifier)
        self.register(LazyGridFooterHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LazyGridFooterHeader.reuseIdentifier)

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true

        self.sectionsBinding?.bind(ActionWith<[Section]> { [weak self] sections in
            self?.sections = sections
            self?.reloadData()
        })

        self.itemsBinding?.bind(ActionWith<[AnyHashable]> { [weak self] items in
            self?.update(items: items)
        })
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func update(items: [AnyHashable]) {
        self.items = items
        let updates = self.calculateUpdates(old: self.items ?? [], new: items)
        guard updates.hasUpdates else { return }
        let isVisible = self.window != nil
        if isVisible {
            self.performBatchUpdates {
                self.deleteItems(at: updates.deleted)
                self.insertItems(at: updates.inserted)
            }
        } else {
            self.reloadData()
        }
    }

    private func calculateUpdates(old: [AnyHashable], new: [AnyHashable], in section: Int = 0) -> TableUpdate {
        let diff = Diff(old, new)
        let inserted = diff.inserted.map { IndexPath(row: $0.0, section: section) }
        let deleted = diff.deleted.map { IndexPath(row: $0.0, section: section) }
        return TableUpdate(deleted: deleted, inserted: inserted)
    }
}

internal class ManualSizedVGridView: LazyVGridView {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.itemsSize {
        case .auto:
            return .zero
        case .manual(let calculationBlock):
            return calculationBlock(collectionView, indexPath)
        }
    }
}

extension LazyVGridView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections?[section].content.count ?? self.items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LazyGridCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear

        if let cell = cell as? LazyGridCell {

            // Sections binding
            if let view = self.sections?[indexPath.section].content[indexPath.row] {
                let accessibility = view.allAccessibilityModifiers
                self.applyAccessibility(cell: cell, modifiers: accessibility)
                cell.configure(view: view)
            }

            // Items binding
            if let item = self.items?[indexPath.row] {
                if item.hashValue != cell.itemHash {
                    let view = self.itemContent?(item)
                    let accessibility = view?.allAccessibilityModifiers ?? []
                    self.applyAccessibility(cell: cell, modifiers: accessibility)
                    cell.configure(view: view)
                }
                cell.itemHash = item.hashValue
            }
        }

        return cell
    }

    private func applyAccessibility(cell: UICollectionViewCell, modifiers: [Modifier]) {
        modifiers.forEach {
            _ = $0.modify(cell)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LazyGridFooterHeader.reuseIdentifier, for: indexPath)
        if kind == UICollectionView.elementKindSectionHeader {
            let header = self.sections?[indexPath.section].header?.display()
            header.map { view.addSubview($0, insets: .zero) }
            return view
        } else {
            let footer = self.sections?[indexPath.section].footer?.display()
            footer.map { view.addSubview($0, insets: .zero) }
            return view
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let header = self.sections?[section].header?.display()
        let size = header?.systemLayoutSizeFitting(collectionView.bounds.size)
        return size ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let footer = self.sections?[section].footer?.display()
        let size = footer?.systemLayoutSizeFitting(collectionView.bounds.size)
        return size ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let selection = self.selection else { return }
        selection.execute(indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard self.selection != nil else { return }
        let item = collectionView.cellForItem(at: indexPath)
        item?.alpha = 0.6
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard self.selection != nil else { return }
        let item = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.2) { [weak item] in
            item?.alpha = 1.0
        }
    }
}

extension LazyVGridView: Delegateable {

    func setDelegate(delegate: Any) {
        self.customDelegate = delegate as? UIScrollViewDelegate
    }
}

extension LazyVGridView: UIScrollViewDelegate {

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

internal class LazyGridFooterHeader: UICollectionReusableView {
    static let reuseIdentifier = String(describing: LazyGridFooterHeader.self)
}

internal class LazyGridCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: LazyGridCell.self)
    private var isHeightCalculated: Bool = false

    var itemHash: Int?
    func configure(view: View?) {
        self.isHeightCalculated = false
        self.removeAllSubviews()
        view.map { self.addSubview($0.display(), insets: .zero) }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            let size = self.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            newFrame.size.height = CGFloat(ceilf(Float(size.height)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        return layoutAttributes
    }
}

public struct PinnedScrollableViews: OptionSet {

    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static let sectionHeaders = PinnedScrollableViews(rawValue: 1 << 0)
    public static let sectionFooters = PinnedScrollableViews(rawValue: 1 << 1)
    public static let all: PinnedScrollableViews = [.sectionHeaders, .sectionFooters]
}


public extension LazyVGrid {

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
}
