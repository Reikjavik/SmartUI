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

internal struct FontModifier: Modifier {

    let font: UIFont

    func modify(_ view: UIView) -> UIView {
        if let label = view as? UILabel {
            label.font = self.font
            return label
        } else if let button = view as? UIButton {
            button.titleLabel?.font = self.font
            return button
        } else if let stackView = view as? UIStackView,
                  let label = stackView.arrangedSubviews.compactMap({ $0 as? UILabel }).first {
            label.font = self.font
            return view
        } else if let textView = view as? UITextView {
            textView.font = self.font
            return textView
        } else if let textField = view as? UITextField {
            textField.font = self.font
            return textField
        }
        return view
    }
}
