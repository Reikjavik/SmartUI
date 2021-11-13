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

class OverlayTests: XCTestCase {

    func testOveralyWithColor() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyDefaultAligned() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignTop() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .top)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignTopLeading() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .topLeading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignTopTrailing() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .topTrailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignLeading() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignTrailing() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignBottom() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .bottom)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignBottomLeading() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .bottomLeading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignBottomTrailing() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .bottomTrailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testOveralyAlignCenter() {
        let view = Color
            .lightGray
            .frame(width: 200, height: 200)
            .overlay(Color.red.frame(width: 50, height: 50), alignment: .center)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
