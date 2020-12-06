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

    internal init(parent: View? = nil, children: [View] = [], modifiers: [Modifier] = []) {
        self.parent = parent
        self.children = children
        self.modifiers = modifiers
    }

    internal var toUIView: UIView { UIView() }

    @discardableResult
    internal func add(to parent: UIView) -> UIView {
        let view = self.display()
        if let stackView = parent as? StackView {
            stackView.addArrangedSubview(view)
        } else {
            view.layout(in: parent, alignment: .center)
        }
        return view
    }

    internal func addChild(child: View, to selfView: UIView) {
        child.add(to: selfView)
    }

    internal func display() -> UIView {
        let initialView = self.toUIView
        let view = self.applyModifiers(on: initialView)
        self.addChildren(to: initialView)
        return view
    }

    internal func applyModifiers(on view: UIView) -> UIView {
        var view = view
        self.modifiers.forEach { view = $0.modify(view) }
        return view
    }

    internal func addChildren(to view: UIView) {
        self.children.forEach { self.addChild(child: $0, to: view) }
    }
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
