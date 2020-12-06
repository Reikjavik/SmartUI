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

internal struct Background: Modifier {

    let view: View

    func modify(_ view: UIView) -> UIView {

        if let divider = view as? DividerView, let color = self.view as? Color {

            divider.backgroundColor = color.color
            return divider
        } else {

            let background = UIView()

            let child = self.view.display()
            child.layout(in: background, alignment: .center)

            background.addSubview(view, insets: .zero)


            let width = child.widthAnchor.constraint(equalTo: view.widthAnchor)
            width.priority = .init(100)
            width.isActive = true

            let height = child.heightAnchor.constraint(equalTo: view.heightAnchor)
            height.priority = .init(100)
            height.isActive = true

            return background
        }
    }
}
