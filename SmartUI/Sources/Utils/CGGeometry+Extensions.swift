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

internal extension UIEdgeInsets {

    init(top: CGFloat = 0.0, bottom: CGFloat = 0.0, left: CGFloat = 0.0, right: CGFloat = 0.0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}

internal extension CGRect {

    func padding(_ value: CGFloat) -> CGRect {
        return self.paddingVertical(value).paddingHorizontal(value)
    }

    func paddingHorizontal(_ value: CGFloat) -> CGRect {
        return CGRect(x: self.minX - value, y: self.minY, width: self.width + value*2, height: self.height)
    }

    func paddingVertical(_ value: CGFloat) -> CGRect {
        return CGRect(x: self.minX, y: self.self.minY - value, width: self.width, height: self.height + value*2)
    }
}
