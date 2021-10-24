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

class TextTests: XCTestCase {

    func testSimpleText() {
        let view = Text("Test")
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithFont() {
        let view = Text("Test").font(.system(size: 20, weight: .bold))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithBigFont() {
        let view = Text("Test").font(.system(size: 40, weight: .bold))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithColor() {
        let view = Text("Test").foregroundColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithAlignmentLeading() {
        let view = Text("Test test test  test test \ntest  test te")
            .multilineTextAlignment(.leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithAlignmentTrailing() {
        let view = Text("Test test test test test \ntest  test te")
            .multilineTextAlignment(.trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithAlignmentCenter() {
        let view = Text("Test test test  test test \ntest  test te")
            .multilineTextAlignment(.center)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextWithNumberOfLines() {
        let view = Text("Test test \n test \n   test \n test te").lineLimit(2)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
