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

public class LazyHStack: View {

    let itemsSize: LazyItemsSize
    let alignment: VerticalAlignment
    let spacing: CGFloat
    let content: () -> [View]

    public init(alignment: VerticalAlignment = .center, itemsSize: LazyItemsSize = .auto, spacing: CGFloat = UIView.defaultSpacing, content: @escaping () -> [View]) {
        self.itemsSize = itemsSize
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
        super.init()
    }

    override var toUIView: UIView {
        switch self.itemsSize {
        case .auto:
            return LazyHStackView(alignment: self.alignment, itemsSize: self.itemsSize, spacing: self.spacing, items: self.content())
        case .manual:
            return ManualSizedLazyHStackView(alignment: self.alignment, itemsSize: self.itemsSize, spacing: self.spacing, items: self.content())
        }
    }

    override func view(view: UIView, didMoveTo parent: UIView) {
        guard parent is UIScrollView else { return }
        print("⚠️ SmartUI: LazyHStack is already a CollectionView, please, do not wrap it with ScrollView, this may cause layout issues.")
    }
}

internal class LazyHStackView: UICollectionView, KeyboardBindable {

    var observer = KeyboardHeightObserver()
    let itemsSize: LazyItemsSize
    let items: [View]

    weak var customDelegate: UIScrollViewDelegate?

    init(alignment: VerticalAlignment,
         itemsSize: LazyItemsSize,
         spacing: CGFloat,
         items: [View]) {
        self.itemsSize = itemsSize
        self.items = items
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.backgroundColor = .clear
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        if case .auto = itemsSize {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        layout.sectionInset = .zero
        self.delegate = self
        self.dataSource = self
        self.register(LazyCollectionCell.self, forCellWithReuseIdentifier: LazyCollectionCell.reuseIdentifier)
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

internal class LazyCollectionCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: LazyCollectionCell.self)
    private weak var collectionView: UICollectionView?
    private var needCalculate: Bool = true
    private var lastCollectionViewHeight: CGFloat = 0.0

    var itemHash: Int?
    func configure(view: View?, in collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.needCalculate = true
        self.removeAllSubviews()
        view.map { self.addSubview($0.display(), insets: .zero) }
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        needCalculate = needCalculate || self.collectionView?.bounds.height != lastCollectionViewHeight
        if needCalculate {
            self.lastCollectionViewHeight = self.collectionView?.bounds.height ?? 0
            self.setNeedsLayout()
            self.layoutIfNeeded()
            let size = self.systemLayoutSizeFitting(CGSize(width: layoutAttributes.size.width, height: self.lastCollectionViewHeight))
            layoutAttributes.frame.size = size
            needCalculate = false
        }
        return layoutAttributes
    }
}

internal class ManualSizedLazyHStackView: LazyHStackView {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.itemsSize {
        case .auto:
            return .zero
        case .manual(let calculationBlock):
            return calculationBlock(collectionView, indexPath)
        }
    }
}

extension LazyHStackView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LazyCollectionCell.reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear

        if let cell = cell as? LazyCollectionCell {
            let view = self.items[indexPath.item]
            let accessibility = view.allAccessibilityModifiers
            self.applyAccessibility(cell: cell, modifiers: accessibility)
            cell.configure(view: view, in: collectionView)
        }

        return cell
    }

    private func applyAccessibility(cell: UICollectionViewCell, modifiers: [Modifier]) {
        cell.resetAccessibilityFields()
        modifiers.forEach {
            _ = $0.modify(cell)
        }
    }
}

extension LazyHStackView: Delegateable {

    func setDelegate(delegate: Any) {
        self.customDelegate = delegate as? UIScrollViewDelegate
    }
}

extension LazyHStackView: UIScrollViewDelegate {

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

public extension LazyHStack {

    func scrollEnabled(_ enabled: Bool) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: .create(enabled)))
    }

    func scrollEnabled(_ enabled: Binding<Bool>) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: enabled))
    }

    func bindToKeyboard(extraOffset: CGFloat = 0.0) -> Self {
        return self.add(modifier: BindToKeyboard(extraOffset: extraOffset))
    }

    func pagingEnabled(_ enabled: Bool) -> Self {
        return self.add(modifier: PagingEnabled(isPagingEnabled: enabled))
    }

    func delegate(_ delegate: UIScrollViewDelegate) -> Self {
        return self.add(modifier: Delegate(delegate: delegate))
    }
}
