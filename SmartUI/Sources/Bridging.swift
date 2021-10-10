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

internal class Container: View {

    internal init(view: View) {
        super.init(children: [view])
    }
}

public class ContainerView: UIView {

    private let content: () -> View

    public init(_ content: @escaping () -> View) {
        self.content = content
        super.init(frame: .zero)
        self.redraw()
    }

    required init?(coder: NSCoder) {
        fatalError("initWithCoder is not supported")
    }

    public func redraw() {
        self.removeAllSubviews()
        let view = self.content()
        let container = Container(view: view)
        self.addSubview(container.display(), insets: .zero)
    }
}

public class CustomView: View {

    private let view: UIView

    override internal var toUIView: UIView {
        return self.view
    }

    public init(view: UIView) {
        self.view = view
        super.init()
    }
}
