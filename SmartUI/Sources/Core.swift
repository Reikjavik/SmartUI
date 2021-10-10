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

public class View {

    private(set) internal var parent: View?
    private(set) internal var children: [View]
    private(set) internal var modifiers: [Modifier]

    internal var sourceView = UIView()

    internal init(parent: View? = nil, children: [View] = [], modifiers: [Modifier] = []) {
        self.parent = parent
        self.children = children
        self.modifiers = modifiers
    }

    internal func display() -> UIView {
        self.sourceView = self.toUIView
        let view = self.applyModifiers()
        self.children.forEach { self.addChild(child: $0) }
        return view
    }

    private func applyModifiers() -> UIView {
        var view = self.sourceView
        self.modifiers.forEach { view = $0.modify(view) }
        return view
    }

    internal func addChild(child: View) {
        let childView = child.display()
        if let stackView = self.sourceView as? StackView {
            stackView.addArrangedSubview(childView)
        } else {
            childView.layout(in: self.sourceView, alignment: .center)
        }
        child.view(view: childView, didMoveTo: self.sourceView)
    }

    // MARK: Override in subclass

    internal var toUIView: UIView { UIView() }
    internal func view(view: UIView, didMoveTo parent: UIView) {}
}

public protocol Modifier {
    func modify(_ view: UIView) -> UIView
}

public extension View {

    static var empty: View { View() }

    func add(modifier: Modifier) -> Self {
        self.modifiers = self.modifiers + [modifier]
        return self
    }
}
