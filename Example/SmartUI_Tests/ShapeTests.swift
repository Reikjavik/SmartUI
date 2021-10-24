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


class ShapeTests: XCTestCase {

    func testCircle() {
        let view = Circle().fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangle() {
        let view = Rectangle().fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRoundedRectangle() {
        let view = RoundedRectangle(cornerRadius: 10).fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangleScale() {
        let view = Rectangle().fill(.blue).scale(0.5)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangleSize() {
        let view = Rectangle().size(width: 100, height: 100).fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testCircleSize() {
        let view = Circle().size(width: 100, height: 100).fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangleRotattion() {
        let view = Rectangle().size(width: 100, height: 100).rotation(.init(degrees: 45.0)).fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangleOffset() {
        let view = Rectangle().size(width: 100, height: 100).offset(x: 50, y: 50).fill(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testRectangleStroke() {
        let view = RoundedRectangle(cornerRadius: 10)
            .size(width: 100, height: 100)
            .rotation(.init(degrees: 45.0))
            .fill(.blue)
            .offset(x: 50, y: 50)
            .stroke(.red, lineWidth: 5.0)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testCircleStroke() {
        let view = Circle()
            .size(width: 100, height: 100)
            .fill(.blue)
            .offset(x: -50, y: -50)
            .stroke(.red, lineWidth: 5.0)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
