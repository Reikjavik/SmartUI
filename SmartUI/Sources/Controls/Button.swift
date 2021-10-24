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

public class Button: Control {

    private let action: Action
    private let title: String?
    private let label: (() -> View)?

    public init(_ title: String, action: @escaping () -> Void) {
        self.action = Action(action)
        self.title = title
        self.label = nil
        super.init()
    }

    public init(action: @escaping () -> Void, label: @escaping () -> View) {
        self.action = Action(action)
        self.title = nil
        self.label = label
        super.init()
    }

    override internal var toUIView: UIView {
        if let title = self.title {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.addAction(action)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.numberOfLines = 0
            return button
        } else if let label = self.label?().display() {
            let container = UIView()
            let button = LabelButton(label: label)
            button.addAction(action)
            container.addSubview(label, insets: .zero)
            container.addSubview(button, insets: .zero)
            return container
        } else {
            return super.toUIView
        }
    }
}

public extension Button {

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

    func background(_ color: Color, for state: UIControl.State) -> Self {
        return self.add(modifier: CustomModifier(modificationBlock: { view -> UIView in
            if let button = view as? UIButton {
                button.setBackgroundImage(UIImage.create(color: color.color), for: state)
            }
            return view
        }))
    }
}

internal class LabelButton: UIButton {

    private weak var highlightingView: UIView?
    private var observation: NSKeyValueObservation?

    deinit {
        self.observation?.invalidate()
        self.observation = nil
    }

    internal init(label: UIView) {
        self.highlightingView = label
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.observation = self.observe(\.isHighlighted, changeHandler: { [weak self] (button, _) in
            if button.isHighlighted {
                self?.highlightingView?.alpha = 0.5
            } else {
                UIView.animate(withDuration: 0.2) {
                    self?.highlightingView?.alpha = 1.0
                }
            }
        })
    }
}
