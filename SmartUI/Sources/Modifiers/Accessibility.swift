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

internal struct Accessibility: Modifier {

    let accessibilityIdentifier: String?
    let accessibilityLabel: String?
    let accessibilityHint: String?
    let accessibilityValue: String?
    let accessibilityLanguage: String?

    func modify(_ view: UIView) -> UIView {
        let allView = [view] + view.find()
        allView.forEach { view in
            self.accessibilityIdentifier.map {
                view.accessibilityIdentifier = $0
            }
            self.accessibilityLabel.map {
                view.accessibilityLabel = $0
            }
            self.accessibilityHint.map {
                view.accessibilityHint = $0
            }
            self.accessibilityValue.map {
                view.accessibilityValue = $0
            }
            self.accessibilityLanguage.map {
                view.accessibilityLanguage = $0
            }
        }
        return view
    }
}

internal struct IsAccessibilityElement: Modifier {

    let value: Bool

    func modify(_ view: UIView) -> UIView {
        let allView = [view] + view.find()
        allView.forEach { view in
            view.isAccessibilityElement = self.value
        }
        return view
    }
}

internal struct AccessibilityElementsHidden: Modifier {

    let value: Bool

    func modify(_ view: UIView) -> UIView {
        let allView = [view] + view.find()
        allView.forEach { view in
            view.accessibilityElementsHidden = self.value
        }
        return view
    }
}

internal struct AccessibilityIgnoresInvertColors: Modifier {

    let value: Bool

    func modify(_ view: UIView) -> UIView {
        let allView = [view] + view.find()
        allView.forEach { view in
            if #available(iOS 11.0, *) {
                view.accessibilityIgnoresInvertColors = self.value
            }
        }
        return view
    }
}

internal struct AccessibilityTraits: Modifier {

    let value: UIAccessibilityTraits

    func modify(_ view: UIView) -> UIView {
        let allView = [view] + view.find()
        allView.forEach { view in
            view.accessibilityTraits = self.value
        }
        return view
    }
}

extension UIView {

    func resetAccessibilityFields() {
        self.accessibilityIdentifier = nil
        self.accessibilityLabel = nil
        self.accessibilityHint = nil
        self.accessibilityValue = nil
        self.accessibilityLanguage = nil
        self.accessibilityElementsHidden = false
        self.accessibilityTraits = .none
    }
}
