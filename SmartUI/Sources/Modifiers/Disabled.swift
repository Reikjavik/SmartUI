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

internal struct Disabled: Modifier {

    let disabled: Binding<Bool>

    func modify(_ view: UIView) -> UIView {
        let handleDisabled: (Bool) -> Void = { [weak view] disabled in
            if let control = view as? UIControl {
                control.isEnabled = !disabled
            } else if let stackView = view as? UIStackView,
                      let toggle = stackView.arrangedSubviews.compactMap({ $0 as? UISwitch }).first {
                toggle.isEnabled = !disabled
            } else if let textView = view as? UITextView {
                textView.isEditable = !disabled
            } else if let stackView = view as? UIStackView,
                      let nestedStack = stackView.arrangedSubviews.compactMap({ $0 as? UIStackView }).first,
                      let slider = nestedStack.arrangedSubviews.compactMap({ $0 as? UISlider }).first {
                slider.isEnabled = !disabled
            } else {
                view?.isUserInteractionEnabled = !disabled
            }
        }
        self.disabled.bind(ActionWith(handleDisabled)).store(in: &view.disposeBag)
        self.disabled.value.map(handleDisabled)
        return view
    }
}
