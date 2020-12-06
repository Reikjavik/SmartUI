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

public class Toggle: Control {

    private let isOn: Binding<Bool>
    private let label: View

    public convenience init(_ title: String? = nil, isOn: Bool) {
        self.init(title, isOn: .constant(isOn))
    }

    public convenience init(_ title: String? = nil, isOn: Binding<Bool>) {
        self.init(isOn: isOn, label: Text(title ?? "").multilineTextAlignment(.leading))
    }

    public convenience init(isOn: Bool, label: View) {
        self.init(isOn: .constant(isOn), label: label)
    }

    public init(isOn: Binding<Bool>, label: View) {
        self.isOn = isOn
        self.label = label
        super.init()
    }

    override internal var toUIView: UIView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let label = self.label.display()
        let width = label.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultHigh
        width.isActive = true

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(SwitchView(isOn: self.isOn))
        return stackView
    }
}

internal class SwitchView: UISwitch {

    private let isOnBinding: Binding<Bool>

    internal init(isOn: Binding<Bool>) {
        self.isOnBinding = isOn
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.isOn = self.isOnBinding.value
        self.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
        self.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc private func valueChanged() {
        self.isOnBinding.update(self.isOn)
    }
}

public struct SwitchToggleStyle {
    
    internal let tint: Color
    
    public init(tint: Color) {
        self.tint = tint
    }
}

public extension Toggle {

    func toggleStyle(_ style: SwitchToggleStyle) -> Self {
        return self.add(modifier: ToggleStyle(style: style))
    }

    func foregroundColor(_ color: Color) -> Self {
        return self.add(modifier: ForegroundColor(color: color))
    }

    func lineLimit(_ number: Int) -> Self {
        return self.add(modifier: LineLimit(lineLimit: number))
    }

    func font(_ font: Font) -> Self {
        return self.add(modifier: FontModifier(font: font))
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
        return self.add(modifier: MultilineTextAlignment(alignment: alignment))
    }

    func alignment(_ alignment: VerticalAlignment) -> Self {
        return self.add(modifier: ToggleAlignment(alignment: alignment))
    }

    func labelsHidden() -> Self {
        return self.add(modifier: LabelsHidden())
    }
}
