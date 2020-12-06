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

internal struct ForegroundColor: Modifier {

    let color: Color

    func modify(_ view: UIView) -> UIView {
        if let label = view as? UILabel {
            label.textColor = self.color.color
            return label
        } else if let image = view as? UIImageView {
            image.tintColor = self.color.color
            return image
        } else if let button = view as? UIButton {
            button.setTitleColor(self.color.color, for: .normal)
            return button
        } else if let textField = view as? UITextField {
            textField.textColor = self.color.color
            return textField
        } else if let textView = view as? TextEditorView {
            textView.color = self.color.color
            return textView
        } else if let textView = view as? UITextView {
            textView.textColor = self.color.color
            return textView
        } else if let stackView = view as? UIStackView,
                  let label = stackView.arrangedSubviews.compactMap({ $0 as? UILabel }).first {
            label.textColor = self.color.color
            return view
        } else {
            return view
        }
    }
}
