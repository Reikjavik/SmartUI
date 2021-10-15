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

private var actionAssociationKey = "extension.Action.actionAssociationKey"

internal extension UIButton {

    private var action: Action? {
        get { objc_getAssociatedObject(self, &actionAssociationKey) as? Action }
        set { objc_setAssociatedObject(self, &actionAssociationKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func addAction(_ action: Action, for event: Event = .touchUpInside) {
        self.action = action
        self.removeTarget(nil, action: nil, for: event)
        self.addTarget(self, action: #selector(self.perfomAction), for: event)
    }

    @objc private func perfomAction() {
        self.action?.execute()
    }
}

internal extension UIGestureRecognizer {

    private var action: Action? {
        get { objc_getAssociatedObject(self, &actionAssociationKey) as? Action }
        set { objc_setAssociatedObject(self, &actionAssociationKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    func addAction(_ action: Action) {
        self.action = action
        self.removeTarget(nil, action: nil)
        self.addTarget(self, action: #selector(self.perfomAction))
    }

    @objc private func perfomAction() {
        self.action?.execute()
    }
}
