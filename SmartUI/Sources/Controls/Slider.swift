// MIT License
//
// Copyright (c) 2021 Igor Tiukavkin.
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

public class Slider<Value: BinaryFloatingPoint>: Control {

    private let value: Publisher<Value>
    private let range: ClosedRange<Value>
    private let step: Value
    private let label: (() -> View)?
    private let minimumValueLabel: (() -> View)?
    private let maximumValueLabel: (() -> View)?
    private let onEditingChanged: ((Bool) -> Void)?

    public init(
        value: Publisher<Value>,
        in range: ClosedRange<Value>,
        step: Value,
        label: (() -> View)? = nil,
        minimumValueLabel: (() -> View)? = nil,
        maximumValueLabel: (() -> View)? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.value = value
        self.range = range
        self.step = step
        self.label = label
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onEditingChanged = onEditingChanged
        super.init()
    }

    override var toUIView: UIView {

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        let label = self.label?()
        let minimumValueLabel = self.minimumValueLabel?()
        let maximumValueLabel = self.maximumValueLabel?()

        let labelView = label?.display()
        labelView.map {
            stackView.addArrangedSubview($0)
            label?.view(view: $0, didMoveTo: stackView)
        }

        let hotizontalStackView = UIStackView()
        hotizontalStackView.axis = .horizontal
        hotizontalStackView.alignment = .center

        let minimumValueLabelView = minimumValueLabel?.display()
        minimumValueLabelView.map {
            hotizontalStackView.addArrangedSubview($0)
            minimumValueLabel?.view(view: $0, didMoveTo: hotizontalStackView)
        }

        let slider = SliderView(
            value: self.value,
            in: self.range,
            step: self.step,
            onEditingChanged: self.onEditingChanged
        )
        slider.translatesAutoresizingMaskIntoConstraints = false
        let width = slider.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        hotizontalStackView.addArrangedSubview(slider)

        let maximumValueLabelView = maximumValueLabel?.display()
        maximumValueLabelView.map {
            hotizontalStackView.addArrangedSubview($0)
            maximumValueLabel?.view(view: $0, didMoveTo: hotizontalStackView)
        }

        stackView.addArrangedSubview(hotizontalStackView)

        return stackView
    }
}

internal class SliderView<Value: BinaryFloatingPoint>: UISlider {

    private let valueBinding: Publisher<Value>
    private let range: ClosedRange<Value>
    private let step: Value
    private let onEditingChanged: ((Bool) -> Void)?

    init(
        value: Publisher<Value>,
        in range: ClosedRange<Value>,
        step: Value,
        onEditingChanged: ((Bool) -> Void)? = nil
    ) {
        self.valueBinding = value
        self.range = range
        self.step = step > 0 ? step : 1
        self.onEditingChanged = onEditingChanged
        super.init(frame: .zero)
        value.bind { [weak self] value in
            if self?.isTracking == true {
                self?.value = Float(value)
            } else {
                self?.setValue(Float(value), animated: true)
            }
        }.store(in: &disposeBag)
        self.minimumValue = Float(range.lowerBound)
        self.maximumValue = Float(range.upperBound)
        self.value = Float(value.value ?? 0)
        self.addTarget(self, action: #selector(self.valueChanged), for: .valueChanged)
        self.addTarget(self, action: #selector(self.editingDidBegin), for: .touchDown)
        self.addTarget(self, action: #selector(self.editingDidEnd), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.editingDidEnd), for: .touchUpOutside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func valueChanged(sender: UISlider) {
        let step = Float(self.step)
        let value = round(sender.value / step) * step
        self.value = value
        guard self.valueBinding.value != Value(value) else { return }
        self.valueBinding.update(Value(value))
    }

    @objc private func editingDidBegin() {
        self.onEditingChanged?(true)
    }

    @objc private func editingDidEnd() {
        self.onEditingChanged?(false)
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return true
    }

    override func accessibilityIncrement() {
        self.onEditingChanged?(true)
        super.accessibilityIncrement()
        self.onEditingChanged?(false)
    }

    override func accessibilityDecrement() {
        self.onEditingChanged?(true)
        super.accessibilityDecrement()
        self.onEditingChanged?(false)
    }
}
