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

public class TextEditor: Control {

    private let title: String?
    private let text: Publisher<String>

    public init(_ title: String? = nil, text: Publisher<String>) {
        self.title = title
        self.text = text
    }

    override internal var toUIView: UIView {
        return TextEditorView(title: self.title, text: self.text)
    }
}

internal class TextEditorView: UITextView, UITextViewDelegate, KeyboardBindable {

    internal var observer = KeyboardHeightObserver()

    private let title: String?
    private let textBinding: Publisher<String>
    internal var heightConstraint: NSLayoutConstraint?
    internal var placeholderColor = UIColor.lightGray
    internal var color = UIColor.black

    internal init(title: String?, text: Publisher<String>) {
        self.title = title
        self.textBinding = text
        super.init(frame: .zero, textContainer: nil)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.textBinding.bind(ActionWith<String> { [weak self] text in
            self?.text = text
            if self?.isFirstResponder != true {
                self?.setupPlaceholder(didEnd: true)
            }
        })
        self.text = self.textBinding.value

        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0.0
        self.backgroundColor = .clear
        self.delegate = self

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultHigh
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultHigh
        height.isActive = true
        self.heightConstraint = height
    }

    override internal func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.setupPlaceholder(didEnd: true)
    }

    internal func textViewDidBeginEditing(_ textView: UITextView) {
        self.setupPlaceholder(didEnd: false)
    }

    internal func textViewDidEndEditing(_ textView: UITextView) {
        self.setupPlaceholder(didEnd: true)
    }

    internal func textViewDidChange(_ textView: UITextView) {
        self.textBinding.update(textView.text)
    }

    private func setupPlaceholder(didEnd: Bool) {
        var isPlaceholder = false
        if self.text == self.title && self.textBinding.value == self.title {
            self.text = self.title
            isPlaceholder = true
        } else if didEnd {
            isPlaceholder = self.text.isEmpty
            self.text = self.text.isEmpty ? self.title : self.text
        } else {
            self.text = self.text == self.title ? "" : self.text
        }
        self.textColor = isPlaceholder ? self.placeholderColor : self.color
    }
}

public extension TextEditor {
    
    func foregroundColor(_ color: Color) -> Self {
        return self.add(modifier: ForegroundColor(color: color))
    }

    func font(_ font: Font) -> Self {
        return self.add(modifier: FontModifier(font: font))
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
        return self.add(modifier: MultilineTextAlignment(alignment: alignment))
    }

    func scrollEnabled(_ enabled: Bool) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: .create(enabled)))
    }

    func scrollEnabled(_ enabled: Binding<Bool>) -> Self {
        return self.add(modifier: ScrollEnabled(isScrollEnabled: enabled))
    }

    func bindToKeyboard(extraOffset: CGFloat = 0.0) -> Self {
        return self.add(modifier: BindToKeyboard(extraOffset: extraOffset))
    }

    func keyboardType(_ type: UIKeyboardType) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            guard let textView = view as? UITextView else { return view }
            textView.keyboardType = type
            return textView
        })
    }

    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            let textField = view as? UITextView
            textField?.returnKeyType = type
            return view
        })
    }

    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            guard let textView = view as? UITextView else { return view }
            textView.dataDetectorTypes = types
            return textView
        })
    }

    func placeholderColor(_ color: Color) -> Self {
        return self.add(modifier: PlaceholderColor(color: color))
    }
}
