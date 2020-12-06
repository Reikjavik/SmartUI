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

protocol StackView {
    func addArrangedSubview(_ view: UIView)
}

extension UIStackView: StackView {}

public class Stack<Alignment>: View {

    var alignment: Alignment?
    var spacing: CGFloat = 0

    override var toUIView: UIView {
        let stackView = UIStackView()
        stackView.spacing = self.spacing
        stackView.distribution = .fill
        return stackView
    }
}

public class HStack: Stack<VerticalAlignment> {

    public init(alignment: VerticalAlignment = .center, spacing: CGFloat = 0, content: () -> [View]) {
        super.init(children: content())
        self.alignment = alignment
        self.spacing = spacing
    }

    override var toUIView: UIView {
        let stackView = super.toUIView as! UIStackView
        stackView.axis = .horizontal
        stackView.alignment = self.alignment?.value ?? .center
        return stackView
    }
}

public class VStack: Stack<HorizontalAlignment> {

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 0, content: () -> [View]) {
        super.init(children: content())
        self.alignment = alignment
        self.spacing = spacing
    }

    override var toUIView: UIView {
        let stackView = super.toUIView as! UIStackView
        stackView.axis = .vertical
        stackView.alignment = self.alignment?.value ?? .center
        return stackView
    }
}

public class ZStack: Stack<Alignment> {

    public init(alignment: Alignment = .center, content: () -> [View]) {
        super.init(children: content())
        self.alignment = alignment
        self.spacing = 0
    }

    override var toUIView: UIView {
        return ZStackView(alignment: self.alignment)
    }
}

internal class ZStackView: UIView, StackView {

    let alignment: Alignment?

    init(alignment: Alignment?) {
        self.alignment = alignment
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addArrangedSubview(_ view: UIView) {
        view.layout(in: self, alignment: self.alignment ?? .center)
        let width = view.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor)
        width.priority = .defaultLow
        width.isActive = true
        let height = view.heightAnchor.constraint(lessThanOrEqualTo: self.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
    }
}
