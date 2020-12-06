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

internal struct ScaleShape: Modifier {

    let scale: CGFloat
    let anchor: Alignment

    func modify(_ view: UIView) -> UIView {
        let scale = CGAffineTransform(scaleX: self.scale, y: self.scale)
        view.transform = view.transform.concatenating(scale)
        switch anchor {
        case .center:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        case .leading:
            view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        case .trailing:
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.5)
        case .top:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        case .bottom:
            view.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        case .topLeading:
            view.layer.anchorPoint = CGPoint(x: 1.0, y: 1.0)
        case .topTrailing:
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        case .bottomLeading:
            view.layer.anchorPoint = CGPoint(x: 1.0, y: 0.0)
        case .bottomTrailing:
            view.layer.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        }
        return view
    }
}
