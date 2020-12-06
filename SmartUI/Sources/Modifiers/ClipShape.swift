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

internal struct ClipShape: Modifier {

    let shape: Shape

    func modify(_ view: UIView) -> UIView {
        return MaskingContainer(shape: shape, view: view)
    }
}

private class MaskingContainer: UIView {

    let shape: Shape
    let view: UIView
    let layoutView: UIView

    init(shape: Shape, view: UIView) {
        self.shape = shape
        self.view = view
        self.layoutView = shape.display()
        super.init(frame: .zero)
        self.setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        self.addSubview(self.view, insets: .zero)
        self.addSubview(self.layoutView, insets: .zero, priority: .defaultLow)
        self.layoutView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.layoutView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.layoutView.alpha = 0.0
        self.layoutView.isUserInteractionEnabled = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let maskView = self.shape.display()
        maskView.backgroundColor = .black
        maskView.frame = self.layoutView.frame
        self.view.mask = maskView
    }
}
