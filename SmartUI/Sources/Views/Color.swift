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

public class Color: View {

    let color: UIColor

    public init(_ color: UIColor) {
        self.color = color
        super.init()
    }

    override internal var toUIView: UIView {
        let view = UIView()
        view.backgroundColor = self.color
        return view
    }

    public func opacity(_ opacity: CGFloat) -> Color {
        let alpha: CGFloat = max(0.0, min(opacity, 1.0))
        return Color(self.color.withAlphaComponent(alpha))
    }
}

public extension Color {
    static var black: Color { Color(.black) }
    static var darkGray: Color { Color(.darkGray) }
    static var lightGray: Color { Color(.lightGray) }
    static var white: Color { Color(.white) }
    static var gray: Color { Color(.gray) }
    static var red: Color { Color(.red) }
    static var green: Color { Color(.green) }
    static var blue: Color { Color(.blue) }
    static var cyan: Color { Color(.cyan) }
    static var yellow: Color { Color(.yellow) }
    static var magenta: Color { Color(.magenta) }
    static var orange: Color { Color(.orange) }
    static var purple: Color { Color(.purple) }
    static var brown: Color { Color(.brown) }
    static var clear: Color { Color(.clear) }
}
