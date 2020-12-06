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

public class LinearGradient: View {

    let gradient: Gradient
    let startPoint: Alignment
    let endPoint: Alignment

    public init(gradient: Gradient, startPoint: Alignment, endPoint: Alignment) {
        self.gradient = gradient
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init()
    }

    override internal var toUIView: UIView {
        return GradientView(
            colors: self.gradient.colors.map { $0.color },
            startPoint: self.startPoint.point,
            endPoint: self.endPoint.point
        )
    }
}

internal class GradientView: UIView {

    init(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        super.init(frame: .zero)
        self.setupGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    func setupGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors.map { $0.cgColor }
        layer?.startPoint = startPoint
        layer?.endPoint = endPoint
    }
}
