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

public class ScrollView: View {

    let axis: Axis
    let showsIndicators: Bool
    let content: () -> View

    public init(_ axis: Axis = .vertical, showsIndicators: Bool = true, content: @escaping () -> View) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.content = content
        super.init()
    }

    override var toUIView: UIView {

        let contentView = self.content().display()

        let scrollView = BindableScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = self.showsIndicators
        scrollView.showsHorizontalScrollIndicator = self.showsIndicators
        scrollView.alwaysBounceVertical = self.axis == .vertical
        scrollView.alwaysBounceHorizontal = self.axis == .horizontal
        scrollView.bounces = true
        scrollView.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true

        switch self.axis {
        case .vertical:
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor).isActive = true
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            let bottom = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            bottom.priority = .defaultLow
            bottom.isActive = true
        case .horizontal:
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor).isActive = true
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            let leading = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            leading.priority = .defaultLow
            leading.isActive = true
        }

        let width = scrollView.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultHigh
        width.isActive = true

        let height = scrollView.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultHigh
        height.isActive = true

        return scrollView
    }
}

class BindableScrollView: UIScrollView, KeyboardBindable {
    var observer = KeyboardHeightObserver()
}

extension BindableScrollView: Delegateable {

    func setDelegate(delegate: Any) {
        self.delegate = delegate as? UIScrollViewDelegate
    }
}

public extension ScrollView {

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
