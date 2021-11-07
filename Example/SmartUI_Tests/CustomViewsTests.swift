// MIT License
//
// Copyright (c) 2021 Igor Tiukavkin.
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

import XCTest
import SmartUI
import SnapshotTesting

class CustomViewsTests: XCTestCase {

    func testProductView() {
        let view = VStack {[
            Divider(),
            ProductRow.create(product: .init(
                emojiIcon: "🍓",
                title: "Product title very long, may be even 2 lines",
                description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                price: 1000)
            )
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testCustomListItemView() {
        let view = VStack(alignment: .fill) {[
            Divider(),
            HStack(alignment: .fill, spacing: 16) {[
                VStack(spacing: 0.0) {[
                    Text("🎉")
                        .font(Font.system(size: 40))
                        .padding(8.0)
                        .frame(width: 60.0, priority: .required)
                        .frame(height: 60.0)
                        .background(Circle().fill(
                            LinearGradient(colors: [
                                Color.lightGray.opacity(0.4), Color.lightGray.opacity(0.1),
                            ], startPoint: .topTrailing, endPoint: .bottomTrailing)
                        ))
                        .cornerRadius(4.0)
                        .clipped(),
                    Spacer()
                ]}.frame(width: 60.0, priority: .required),
                VStack(alignment: .fill, spacing: 8.0) {[
                    HStack(alignment: .firstTextBaseline, spacing: 8.0, content: {[
                        Text("Left aligned label")
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .font(.subheadline)
                            .foregroundColor(.black),
                        Text("Right")
                            .multilineTextAlignment(.trailing)
                            .lineLimit(1)
                            .foregroundColor(.black)
                            .font(.callout)
                            .contentHuggingPriority(.required, for: .horizontal)
                    ]}),
                    HStack(spacing: 16.0) {[
                        Text("Title label could also be more than 1 line")
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black),
                        Text(">")
                            .font(.system(size: 16.0, weight: .bold))
                            .frame(width: 20, height: 20, priority: .required)
                    ]},
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.gray)
                        .contentHuggingPriority(.defaultLow, for: .vertical),
                    Spacer()
                ]}
            ]}
            .padding([.top, .bottom], 10.0)
            .padding([.leading, .trailing], 12.0)
            .frame(width: .infinity),
            Divider()
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
