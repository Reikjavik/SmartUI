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
import SwiftUI

public class LinearGradient: View {

    let stops: [Gradient.Stop]
    let startPoint: Alignment
    let endPoint: Alignment

    public init(stops: [Gradient.Stop], startPoint: Alignment, endPoint: Alignment) {
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init()
    }

    public convenience init(colors: [Color], startPoint: Alignment, endPoint: Alignment) {
        self.init(gradient: .init(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    public convenience init(gradient: Gradient, startPoint: Alignment, endPoint: Alignment) {
        let stops = gradient.colors.enumerated().map {
            Gradient.Stop(color: $0.element, location: CGFloat($0.offset) / CGFloat(gradient.colors.count - 1))
        }
        self.init(stops: stops, startPoint: startPoint, endPoint: endPoint)
    }

    override internal var toUIView: UIView {
        return GradientView(
            stops: self.stops,
            startPoint: self.startPoint.point,
            endPoint: self.endPoint.point
        )
    }

    override func view(view: UIView, didMoveTo parent: UIView) {
        let width = view.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = view.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true
    }
}

internal class GradientView: UIView {

    init(stops: [Gradient.Stop], startPoint: CGPoint, endPoint: CGPoint) {
        super.init(frame: .zero)
        self.setupGradient(stops: stops, startPoint: startPoint, endPoint: endPoint)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }

    func setupGradient(stops: [Gradient.Stop], startPoint: CGPoint, endPoint: CGPoint) {
        let stops = stops.sorted(by: { $0.location < $1.location })
        let colors = stops.map { $0.color.color.cgColor }
        let locations = stops.map { $0.location as NSNumber }
        let layer = self.layer as? CAGradientLayer
        layer?.colors = colors
        layer?.locations = locations
        layer?.startPoint = startPoint
        layer?.endPoint = endPoint
    }
}
