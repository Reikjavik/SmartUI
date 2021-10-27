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

public class Text: View {

    let string: String?
    let attributedString: NSAttributedString?

    public init(_ string: String) {
        self.string = string
        self.attributedString = nil
        super.init()
    }

    public init(_ attributedString: NSAttributedString) {
        self.string = nil
        self.attributedString = attributedString
        super.init()
    }

    override var toUIView: UIView {
        let label = UILabel()
        if let string = self.string {
            label.text = string
        } else if let attributedString = self.attributedString {
            label.attributedText = attributedString
        }
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }
}

public typealias Font = UIFont

public extension Font {

    static func system(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }
    func weight(_ weight: UIFont.Weight = .regular) -> UIFont {
        return Font.system(size: self.pointSize, weight: weight)
    }
}

public extension Text {

    func foregroundColor(_ color: Color) -> Self {
        return self.add(modifier: ForegroundColor(color: color))
    }

    func lineLimit(_ number: Int) -> Self {
        return self.add(modifier: LineLimit(lineLimit: number))
    }

    func font(_ font: Font) -> Self {
        return self.add(modifier: FontModifier(font: font))
    }

    func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
        return self.add(modifier: MultilineTextAlignment(alignment: alignment))
    }
}

public extension Font {

    @available(iOS 11.0, *)
    static var largeTitle: UIFont {
        return UIFont.preferredFont(forTextStyle: .largeTitle)
    }

    static var title1: UIFont {
        return UIFont.preferredFont(forTextStyle: .title1)
    }

    static var title2: UIFont {
        return UIFont.preferredFont(forTextStyle: .title2)
    }

    static var title3: UIFont {
        return UIFont.preferredFont(forTextStyle: .title3)
    }

    static var headline: UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }

    static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }

    static var body: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }

    static var callout: UIFont {
        return UIFont.preferredFont(forTextStyle: .callout)
    }

    static var footnote: UIFont {
        return UIFont.preferredFont(forTextStyle: .footnote)
    }

    static var caption1: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption1)
    }

    static var caption2: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption2)
    }
}
