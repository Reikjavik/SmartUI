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

public class Divider: View {

    static let height: CGFloat = 1.0 / UIScreen.main.scale

    public init() {
        super.init()
    }
    
    override var toUIView: UIView {
        let view = DividerView()
        view.backgroundColor = .lightGray
        return view
    }

    override func add(to parent: UIView) -> UIView {
        let view = super.add(to: parent)
        self.view(view: view, didMoveTo: parent)
        return view
    }

    func view(view: UIView, didMoveTo parent: UIView) {

        let constraint: NSLayoutConstraint
        let size: NSLayoutConstraint

        let isHorizontal = (parent as? UIStackView)?.axis == .vertical

        if isHorizontal {
            size = view.heightAnchor.constraint(equalToConstant: Divider.height)
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            constraint = view.widthAnchor.constraint(equalTo: parent.widthAnchor)
        } else {
            size = view.widthAnchor.constraint(equalToConstant: Divider.height)
            view.setContentHuggingPriority(.defaultLow, for: .vertical)
            constraint = view.heightAnchor.constraint(equalTo: parent.heightAnchor)
        }
        constraint.priority = .defaultHigh
        constraint.isActive = true

        size.priority = .defaultHigh
        size.isActive = true
    }
}

internal class DividerView: UIView {

}
