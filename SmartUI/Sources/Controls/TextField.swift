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

public class TextField: Control {

    private let title: String
    private let text: Binding<String>
    private let onEditingChanged: ActionWith<Bool>
    private let onCommit: Action

    public init(_ title: String,
                text: Binding<String>,
                onEditingChanged: @escaping (Bool) -> Void = { _ in },
                onCommit: @escaping () -> Void = {}) {
        self.title = title
        self.text = text
        self.onEditingChanged = ActionWith(onEditingChanged)
        self.onCommit = Action(onCommit)
        super.init()
    }

    override internal var toUIView: UIView {
        return TextFieldView(
            title: self.title,
            value: self.text,
            onEditingChanged: self.onEditingChanged,
            onCommit: self.onCommit
        )
    }
}

internal class TextFieldView: UITextField, UITextFieldDelegate {

    private let title: String
    private let value: Binding<String>
    private let onEditingChanged: ActionWith<Bool>
    private let onCommit: Action
    internal var placeholderColor: UIColor = .lightGray

    internal init(title: String,
         value: Binding<String>,
         onEditingChanged: ActionWith<Bool>,
         onCommit: Action) {
        self.title = title
        self.value = value
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        self.setupPlaceholder()
    }

    private func setup() {
        self.value.bind(ActionWith<String> { [weak self] text in
            self?.text = text
        })
        self.text = self.value.value
        self.borderStyle = .none
        self.delegate = self
        self.addTarget(self, action: #selector(self.didChangeText(textField:)), for: .editingChanged)

        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultHigh
        width.isActive = true
    }

    private func setupPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(
            string: self.isFirstResponder ? "" : self.title,
            attributes: [.foregroundColor: self.placeholderColor]
        )
    }

    @objc private func didChangeText(textField: UITextField) {
        self.value.update(textField.text ?? "")
    }

    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.onEditingChanged.execute(true)
        return true
    }

    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupPlaceholder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onCommit.execute()
        textField.resignFirstResponder()
        return true
    }

    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.setupPlaceholder()
        self.onEditingChanged.execute(false)
    }

    override internal func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return self.bounds.padding(16.0).contains(point)
    }
}

public extension TextField {

    func foregroundColor(_ color: Color) -> Self {
        return self.add(modifier: ForegroundColor(color: color))
    }

    func font(_ font: Font) -> Self {
        return self.add(modifier: FontModifier(font: font))
    }

    func keyboardType(_ type: UIKeyboardType) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            guard let textField = view as? UITextField else { return view }
            textField.keyboardType = type
            return textField
        })
    }

    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            let textField = view as? UITextField
            textField?.returnKeyType = type
            return view
        })
    }

    func placeholderColor(_ color: Color) -> Self {
        return self.add(modifier: PlaceholderColor(color: color))
    }
}
