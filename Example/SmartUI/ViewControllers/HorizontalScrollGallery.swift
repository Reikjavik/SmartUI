//
//  HorizontalScrollGallery.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 06.12.2020.
//  Copyright © 2020 Igor Tiukavkin. All rights reserved.
//

import UIKit
import SmartUI

class HorizontalScrollGallery: UIViewController {

    private var contentView: ContainerView?
    private let emojis = ["🥑", "🥨", "🧀", "🍳", "🍕", "🥘", "🍟"].shuffled()
    private lazy var viewSize = Distinct<CGSize>()
    private let pageControl = UIPageControl()

    let itemBgColor = Color(UIColor(red: 86/255, green: 142/255, blue: 166/255, alpha: 1.0))
    let itemCircleColor = Color(UIColor(red: 48/255, green: 95/255, blue: 114/255, alpha: 1.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.pageControl.numberOfPages = self.emojis.count
        self.pageControl.pageIndicatorTintColor = .lightGray
        self.pageControl.currentPageIndicatorTintColor = .darkGray

        self.contentView = ContainerView { [unowned self] in
            List {[
                self.galleryView,
                CustomView(view: self.pageControl),
                Text("Products")
                    .font(Font.system(size: 20, weight: .semibold))
                    .padding(8),
                ProductRow.create(product: .carrot),
                Divider(),
                ProductRow.create(product: .avocado),
                Divider(),
                ProductRow.create(product: .apple),
                Spacer().frame(height: 32.0)
            ]}.separatorStyle(.none)
        }
        self.contentView?.layout(in: view)
    }
    
    private var galleryView: View {
        ScrollView(.horizontal, showsIndicators: false) { [unowned self] in
            HStack(alignment: .fill) {
                self.emojis.map { emoji in
                    ZStack {[
                        RoundedRectangle(cornerRadius: 12)
                            .fill(self.itemBgColor)
                            .scale(0.9),
                        Circle()
                            .fill(self.itemCircleColor)
                            .scale(0.8),
                        Text(emoji)
                            .font(Font.system(size: 80))
                    ]}
                    .frame(width: self.view.bounds.width)
                    .padding(.top, 12)
                    .onTapGesture { [weak self] in
                        self?.showAlert()
                    }
                }
            }
        }
        .delegate(self)
        .pagingEnabled(true)
        .frame(width: self.view.bounds.width)
        .aspectRatio(16/9)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewSize.distinct(value: self.view.bounds.size) { [unowned self] in
            self.contentView?.redraw()
        }
    }

    private func showAlert() {
        let vc = UIAlertController(
            title: "Tap",
            message: "You did a tap on " + self.emojis[self.pageControl.currentPage],
            preferredStyle: .alert
        )
        vc.addAction(.init(title: "OK", style: .cancel, handler: nil))
        self.present(vc, animated: true, completion: nil)
    }
}

extension HorizontalScrollGallery: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        self.pageControl.currentPage = min(self.emojis.count - 1, max(page, 0))
    }
}
