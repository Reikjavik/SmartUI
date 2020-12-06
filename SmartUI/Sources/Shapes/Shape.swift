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

public class Shape: View {

    override func add(to parent: UIView) -> UIView {
        let view = super.add(to: parent)
        (view as? ShapeView)?.setupShapeConstraints()
        return view
    }
}

internal class ShapeView: UIView {

    func setupShapeConstraints() {
        let width = self.widthAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        width.priority = .defaultLow
        width.isActive = true

        let height = self.heightAnchor.constraint(equalToConstant: UIView.maxConstraintConstantValue)
        height.priority = .defaultLow
        height.isActive = true
    }
}

public extension Shape {

    func offset(_ offset: CGSize) -> Shape {
        return self.add(modifier: OffsetShape(x: offset.width, y: offset.height))
    }

    func offset(x: CGFloat = 0, y: CGFloat = 0) -> Shape {
        return self.add(modifier: OffsetShape(x: x, y: y))
    }

    func scale(_ scale: CGFloat, anchor: Alignment = .center) -> Shape {
        return self.add(modifier: ScaleShape(scale: scale, anchor: anchor))
    }

    func fill(_ color: Color) -> Shape {
        return self.add(modifier: FillShape(style: color))
    }

    func fill(_ gradient: LinearGradient) -> Shape {
        return self.add(modifier: FillShape(style: gradient))
    }

    func stroke(_ color: Color, lineWidth: CGFloat = 1) -> Shape {
        return self.add(modifier: StrokeShape(color: color, lineWidth: lineWidth))
    }

    func rotation(_ angle: Angle) -> Shape {
        return self.add(modifier: Rotation(angle: angle))
    }

    func size(width: CGFloat? = nil, height: CGFloat? = nil) -> Shape {
        return self.add(modifier: SizeShape(width: width, height: height))
    }
}
