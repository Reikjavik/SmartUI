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

public class Image: View {

    let content: UIImage?

    public init(uiImage: UIImage) {
        self.content = uiImage
        super.init()
    }

    public init(_ name: String, bundle: Bundle? = nil) {
        self.content = UIImage(named: name, in: bundle, compatibleWith: nil)
        super.init()
    }

    override internal var toUIView: UIView {
        let imageView = UIImageView()
        imageView.image = self.content
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

public extension Image {

    func foregroundColor(_ color: Color) -> Self {
        return self.add(modifier: ForegroundColor(color: color))
    }

    func resizeable() -> Self {
        return self.add(modifier: Resizeable())
    }

}
