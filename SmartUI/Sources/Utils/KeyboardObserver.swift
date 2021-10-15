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

import Foundation

public final class KeyboardHeightObserver: NSObject {

    private var onWillShow: ActionWith<CGFloat> = .empty
    private var onWillHide: Action = .empty

    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    public func onWillShow(_ action: @escaping (CGFloat) -> Void) {
        self.onWillShow = .init(action)
    }

    public func onWillHide(_ action: @escaping () -> Void) {
        self.onWillHide = .init(action)
    }

    @objc func keyboardWillShowNotification(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.onWillShow.execute(keyboardSize.height)
    }

    @objc func keyboardWillHideNotification(notification: Notification) {
        self.onWillHide.execute()
    }
}
