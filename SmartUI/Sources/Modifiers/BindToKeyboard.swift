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

internal struct BindToKeyboard: Modifier {

    let extraOffset: CGFloat

    func modify(_ view: UIView) -> UIView {
        (view as? KeyboardBindable)?.bindToKeyboard(extraOffset: self.extraOffset)
        return view
    }
}

internal protocol KeyboardBindable: UIScrollView {
    var extraOffset: CGFloat { get set }
    var defaultInsets: UIEdgeInsets { get set }
}

internal extension UIScrollView {

    func bindToKeyboard(extraOffset: CGFloat) {
        (self as? KeyboardBindable)?.extraOffset = extraOffset
        (self as? KeyboardBindable)?.defaultInsets = self.contentInset
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShowNotification(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.contentInset.bottom = keyboardSize.height + ((self as? KeyboardBindable)?.extraOffset ?? 0.0)
    }

    @objc func keyboardWillHideNotification(notification: Notification) {
        self.contentInset = (self as? KeyboardBindable)?.defaultInsets ?? .zero
    }
}
