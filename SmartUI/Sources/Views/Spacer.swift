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

public class Spacer: View {

    let minLenght: CGFloat?

    public init(minLength: CGFloat? = nil) {
        self.minLenght = minLength
        super.init()
    }

    override var toUIView: UIView {
        let view = UIView()
        view.setContentHuggingPriority(.init(rawValue: 0), for: .vertical)
        view.setContentHuggingPriority(.init(rawValue: 0), for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }

    override func add(to parent: UIView) -> UIView {
        let view = super.add(to: parent)
        self.view(view: view, didMoveTo: parent)
        return view
    }

    func view(view: UIView, didMoveTo parent: UIView) {

        let isVertical = (parent as? UIStackView)?.axis == .vertical
        let constant = { $0 == .infinity ? UIView.maxConstraintConstantValue : $0 }

        if isVertical {
            self.minLenght.map {
                let minHeight = view.heightAnchor.constraint(greaterThanOrEqualToConstant: constant($0))
                minHeight.priority = .defaultHigh
                minHeight.isActive = true
            }
        } else {
            self.minLenght.map {
                let minWidth = view.widthAnchor.constraint(greaterThanOrEqualToConstant: constant($0))
                minWidth.priority = .defaultHigh
                minWidth.isActive = true
            }
        }
    }
}
