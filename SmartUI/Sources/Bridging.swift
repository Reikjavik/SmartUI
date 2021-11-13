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

public class ContainerView: UIView {

    public enum Alignment {
        case fill
        case center
        case top
        case topLeading
        case topTrailing
        case leading
        case trailing
        case bottom
        case bottomLeading
        case bottomTrailing
    }

    let alignment: Alignment
    let content: () -> View

    public init(alignment: Alignment = .center, content: @escaping () -> View) {
        self.alignment = alignment
        self.content = content
        super.init(frame: .zero)
        self.redraw()
    }

    required init?(coder: NSCoder) {
        fatalError("initWithCoder is not supported")
    }

    public func redraw(animation: Animation? = nil) {
        self.removeAllSubviews()
        let content = self.content()
        let view = content.display()
        switch self.alignment {
        case .fill:
            self.addSubview(view, insets: .zero)
        case .center:
            view.layout(in: self, alignment: .center)
        case .top:
            view.layout(in: self, alignment: .top)
        case .topLeading:
            view.layout(in: self, alignment: .topLeading)
        case .topTrailing:
            view.layout(in: self, alignment: .topTrailing)
        case .leading:
            view.layout(in: self, alignment: .leading)
        case .trailing:
            view.layout(in: self, alignment: .trailing)
        case .bottom:
            view.layout(in: self, alignment: .bottom)
        case .bottomLeading:
            view.layout(in: self, alignment: .bottomLeading)
        case .bottomTrailing:
            view.layout(in: self, alignment: .bottomTrailing)
        }
        content.view(view: view, didMoveTo: self)
        animation.map { self.layer.add($0.animation, forKey: "SmartUI.Animation") }
    }

    @discardableResult
    public func redraw(on binding: AnyBinding, animation: Animation? = nil) -> ContainerView {
        binding.onChange { [weak self] in
            DispatchQueue.main.async {
                self?.redraw(animation: animation)
            }
        }
        return self
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
