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

internal struct Frame: Modifier {

    let width: CGFloat?
    let height: CGFloat?
    let minWidth: CGFloat?
    let maxWidth: CGFloat?
    let minHeight: CGFloat?
    let maxHeight: CGFloat?
    let priority: UILayoutPriority

    func modify(_ view: UIView) -> UIView {
        let constant = { $0 == .infinity ? UIView.maxConstraintConstantValue : $0 }
        width.map {
            let widht = view.widthAnchor.constraint(equalToConstant: constant($0))
            widht.priority = self.priority
            widht.isActive = true
        }
        height.map {
            let height = view.heightAnchor.constraint(equalToConstant: constant($0))
            height.priority = self.priority
            height.isActive = true
        }
        minWidth.map {
            let minWidth = view.widthAnchor.constraint(greaterThanOrEqualToConstant: constant($0))
            minWidth.priority = self.priority
            minWidth.isActive = true
        }
        maxWidth.map {
            let maxWidth = view.widthAnchor.constraint(lessThanOrEqualToConstant: constant($0))
            maxWidth.priority = self.priority
            maxWidth.isActive = true
        }
        minHeight.map {
            let minHeight = view.heightAnchor.constraint(greaterThanOrEqualToConstant: constant($0))
            minHeight.priority = self.priority
            minHeight.isActive = true
        }
        maxHeight.map {
            let maxHeight = view.heightAnchor.constraint(lessThanOrEqualToConstant: constant($0))
            maxHeight.priority = self.priority
            maxHeight.isActive = true
        }
        return view
    }
}
