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

public enum VerticalAlignment: Equatable  {

    case fill
    case top
    case center
    case bottom
    case firstTextBaseline
    case lastTextBaseline

    internal var value: UIStackView.Alignment {
        switch self {
        case .fill:
            return .fill
        case .top:
            return .top
        case .center:
            return .center
        case .bottom:
            return .bottom
        case .firstTextBaseline:
            return .firstBaseline
        case .lastTextBaseline:
            return .lastBaseline
        }
    }
}

public enum HorizontalAlignment: Equatable  {

    case fill
    case leading
    case center
    case trailing

    internal var value: UIStackView.Alignment {
        switch self {
        case .fill:
            return .fill
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        }
    }
}

public enum Alignment: Equatable {

    case center
    case leading
    case trailing
    case top
    case bottom
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing

    internal var point: CGPoint {
        switch self {
        case .center:
            return CGPoint(x: 0.5, y: 0.5)
        case .leading:
            return CGPoint(x: 0.0, y: 0.5)
        case .trailing:
            return CGPoint(x: 1, y: 0.5)
        case .top:
            return CGPoint(x: 0.5, y: 0.0)
        case .bottom:
            return CGPoint(x: 0.5, y: 1.0)
        case .topLeading:
            return CGPoint(x: 0.0, y: 0.0)
        case .topTrailing:
            return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeading:
            return CGPoint(x: 0.0, y: 1.0)
        case .bottomTrailing:
            return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

public enum TextAlignment {
    
    case leading
    case trailing
    case center

    internal var textAlignment: NSTextAlignment {
        switch self {
        case .leading:
            return.left
        case .trailing:
            return .right
        case .center:
            return .center
        }
    }

    internal var contentAlignment: UIControl.ContentHorizontalAlignment {
        switch self {
        case .leading:
            return .left
        case .trailing:
            return .right
        case .center:
            return .center
        }
    }
}
