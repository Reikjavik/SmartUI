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

public extension UIView {

    internal static var maxConstraintConstantValue: CGFloat {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }

    func addSubview(_ view: UIView, insets: UIEdgeInsets, priority: UILayoutPriority = .required) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        [view.topAnchor.constraint(equalTo: self.topAnchor, constant: insets.top),
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -insets.bottom),
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: insets.left),
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -insets.right)].forEach {
            $0.priority = priority
            $0.isActive = true
        }
    }

    func layout(in container: UIView, alignment: Alignment = .center, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        switch alignment {
        case .center:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        case .leading:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        case .trailing:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right).isActive = true
            self.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        case .top:
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        case .bottom:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
            self.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        case .topLeading:
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
        case .topTrailing:
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right).isActive = true
        case .bottomLeading:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -insets.right).isActive = true
        case .bottomTrailing:
            self.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: insets.top).isActive = true
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom).isActive = true
            self.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: insets.left).isActive = true
            self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -insets.right).isActive = true
        }
    }

    func removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }
}
