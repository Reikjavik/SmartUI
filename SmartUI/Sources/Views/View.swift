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

public extension View {

    func background(_ view: View) -> View {
        return self.add(modifier: Background(view: view))
    }

    func padding(_ edges: Edge.Set = .all, _ length: CGFloat = UIView.defaultSpacing) -> View {
        return self.add(modifier: Padding(edges: edges, length: length))
    }

    func padding(_ length: CGFloat = UIView.defaultSpacing) -> View {
        return self.add(modifier: Padding(edges: .all, length: length))
    }

    func frame(width: CGFloat? = nil, height: CGFloat? = nil, priority: UILayoutPriority = .init(999)) -> View {
        return self.add(modifier: Frame(width: width, height: height, minWidth: nil, maxWidth: nil, minHeight: nil, maxHeight: nil, priority: priority))
    }

    func frame(minWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, maxHeight: CGFloat? = nil) -> View {
        return self.add(modifier: Frame(width: nil, height: nil, minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight, priority: .init(999)))
    }

    func aspectRatio(_ aspectRatio: CGSize, contentMode: ContentMode = .fit) -> Self {
        return self.add(modifier: AspectRatio(aspectRatio: aspectRatio.width / aspectRatio.height, contentMode: contentMode))
    }

    func aspectRatio(_ aspectRatio: CGFloat, contentMode: ContentMode = .fit) -> Self {
        return self.add(modifier: AspectRatio(aspectRatio: aspectRatio, contentMode: contentMode))
    }

    func clipped(_ clipped: Bool = true) -> Self {
        return self.add(modifier: Clipped(clipped: clipped))
    }

    func overlay(_ view: View, alignment: Alignment = .center) -> View {
        return self.add(modifier: Overlay(view: view, alignment: alignment))
    }

    func cornerRadius(_ radius: CGFloat) -> Self {
        return self.add(modifier: CornerRadius(radius: radius))
    }

    func border(_ color: Color, width: CGFloat = 1) -> Self {
        return self.add(modifier: Border(color: color, width: width))
    }

    func shadow(color: Color, radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0) -> View {
        return self.add(modifier: Shadow(color: color, radius: radius, x: x, y: y))
    }

    func transformEffect(_ transform: CGAffineTransform, concatenate: Bool = true) -> Self {
        return self.add(modifier: Transform(affineTransform: transform, concatenate: concatenate))
    }

    func onTapGesture(count: Int = 1, perform action: @escaping () -> Void) -> Self {
        return self.add(modifier: TapGesture(count: count, action: Action(action)))
    }

    func tintColor(_ color: Color) -> Self {
        return self.add(modifier: CustomModifier { view -> UIView in
            view.tintColor = color.color
            return view
        })
    }

    func alpha(_ alpha: CGFloat) -> Self {
        return self.alpha(.create(alpha))
    }

    func alpha(_ alpha: Binding<CGFloat>) -> Self {
        return self.add(modifier: Alpha(alpha: alpha))
    }

    func clipShape(_ shape: Shape) -> View {
        return self.add(modifier: ClipShape(shape: shape))
    }

    func hidden(_ hidden: Bool = true) -> Self {
        return self.hidden(.create(hidden))
    }

    func hidden(_ hidden: Binding<Bool>) -> Self {
        return self.add(modifier: Hidden(isHidden: hidden))
    }

    func contentHuggingPriority(_ priority: UILayoutPriority, for direction: Layout.Direction = .all) -> Self {
        return self.add(modifier: ContentHuggingPriority(priority: priority, direction: direction))
    }

    func contentCompressionResistance(_ priority: UILayoutPriority, for direction: Layout.Direction = .all) -> Self {
        return self.add(modifier: ContentCompressionResistance(priority: priority, direction: direction))
    }
   

    func accessibility(
        identifier: String? = nil,
        label: String? = nil,
        hint: String? = nil,
        value: String? = nil,
        language: String? = nil
    ) -> View {
        return self.add(
            modifier: Accessibility(
                accessibilityIdentifier: identifier,
                accessibilityLabel: label,
                accessibilityHint: hint,
                accessibilityValue: value,
                accessibilityLanguage: language
            )
        )
    }

    func customModifier(_ modification: @escaping (UIView) -> UIView) -> Self {
        return self.add(modifier: CustomModifier(modificationBlock: modification))
    }

    func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        return self.add(modifier: SelectionStyle(style: style))
    }

    func selectionStyle(_ color: Color) -> Self {
        return self.add(modifier: SelectionStyle(color: color))
    }
}
