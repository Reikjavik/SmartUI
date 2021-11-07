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

class StackTests: XCTestCase {

    func testHStack() {
        let view = HStack(spacing: 36.0) {[
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50),
            Text("123"),
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackWithSpacer() {
        let view = HStack(spacing: 36.0) {[
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50),
            Text("123"),
            Spacer(),
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentCenter() {
        let view = HStack(alignment: .center) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentTop() {
        let view = HStack(alignment: .top) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentBottom() {
        let view = HStack(alignment: .bottom) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentFill() {
        let view = HStack(alignment: .fill) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentFirstTextBaseline() {
        let view = HStack(alignment: .firstTextBaseline) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2)),
            Text("Hello, world!\nHello, world!").padding().background(Color.red.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStackAlignmentLastTextBaseline() {
        let view = HStack(alignment: .lastTextBaseline) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2)),
            Text("Hello, world!\nHello, world!").padding().background(Color.red.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStack() {
        let view = VStack(spacing: 36.0) {[
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50),
            Text("123"),
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStackWithSpacer() {
        let view = VStack(spacing: 36.0) {[
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50),
            Text("123"),
            Spacer().frame(width: .infinity),
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStackAlignmentLeading() {
        let view = VStack(alignment: .leading) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStackAlignmentTrailing() {
        let view = VStack(alignment: .trailing) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStackAlignmentCenter() {
        let view = VStack(alignment: .center) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStackAlignmentFill() {
        let view = VStack(alignment: .fill) {[
            Text("Hello, world!").padding().background(Color.brown.opacity(0.2))
        ]}.frame(width: .infinity, height: 200)
          .background(Color.lightGray.opacity(0.2))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testHStacksCombination() {
        let view = HStack {[
            Text("Hello"),
            VStack(spacing: 36.0) {[
                Rectangle()
                    .fill(.red)
                    .frame(width: 50, height: 50),
                Text("123")
                    .contentCompressionResistance(.required),
                Spacer().frame(height: .infinity),
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
            ]}
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testVStacksCombination() {
        let view = VStack {[
            Text("Hello"),
            HStack(spacing: 36.0) {[
                Rectangle()
                    .fill(.red)
                    .frame(width: 50, height: 50),
                Text("123")
                    .contentCompressionResistance(.required),
                Spacer().frame(width: .infinity),
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
            ]}
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testZStack() {
        let view = ZStack {[
            Rectangle()
                .fill(.red)
                .frame(width: 50, height: 50),
            Circle()
                .fill(.blue)
                .frame(width: 50, height: 50),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testZStackAlignmentTop() {
        let view = ZStack(alignment: .top) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testZStackAlignmentTopLeading() {
        let view = ZStack(alignment: .topLeading) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testZStackAlignmentTopTrailing() {
        let view = ZStack(alignment: .topTrailing) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }



    func testZStackAlignmentLeading() {
        let view = ZStack(alignment: .leading) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }



    func testZStackAlignmentTrailing() {
        let view = ZStack(alignment: .trailing) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }



    func testZStackAlignmentBottomLeading() {
        let view = ZStack(alignment: .bottomLeading) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testZStackAlignmentBottom() {
        let view = ZStack(alignment: .bottom) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }


    func testZStackAlignmentBottomTrailling() {
        let view = ZStack(alignment: .bottomTrailing) {[
            Rectangle()
                .fill(.red)
                .frame(width: 150, height: 150),
            Circle()
                .fill(.blue)
                .frame(width: 100, height: 100),
            Text("123")
                .foregroundColor(.white),
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testLazyHStack() {
        let view = LazyHStack(spacing: 36.0) {[
            Rectangle().fill(.red).frame(width: 100, height: 100),
            Text("123"),
            Circle().fill(.blue).frame(width: 100, height: 100),
            Rectangle().fill(.red).frame(width: 100, height: 100),
            Text("123"),
            Circle().fill(.blue).frame(width: 100, height: 100)
        ]}.frame(height: 100)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testLazyHStackManualSized() {
        let view = LazyHStack(itemsSize: .manual({ _, _ in
            return CGSize(width: 50, height: 50)
        }), spacing: 26.0) {[
            Rectangle().fill(.red).frame(width: 100, height: 100),
            Text("123"),
            Circle().fill(.blue).frame(width: 100, height: 100),
            Rectangle().fill(.red).frame(width: 100, height: 100),
            Text("123"),
            Circle().fill(.blue).frame(width: 100, height: 100)
        ]}.frame(height: 100)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
