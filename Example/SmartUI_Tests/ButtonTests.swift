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

class ButtonTests: XCTestCase {

    func testSimpleButton() {
        let view = Button("Test button") {}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonWithFont() {
        let view = Button("Test button") {}
            .font(.system(size: 14.0, weight: .bold))
            .foregroundColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonWithLineLimit() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .lineLimit(2)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonAlignmentCenter() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .multilineTextAlignment(.center)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonAlignmentLeading() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .multilineTextAlignment(.leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonAlignmentTrailing() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .multilineTextAlignment(.trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testCustomButton() {
        let view = Button(action: {}, label: {
            Text("Custom button")
                .foregroundColor(.white)
                .font(.system(size: 12.0, weight: .bold))
                .padding([.top, .bottom], 8.0)
                .padding([.leading, .trailing], 16.0)
                .background(Color.blue)
                .cornerRadius(8.0)
        })
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonWithBackground() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .background(Color.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonWithBackgroundDisabled() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .disabled(true)
            .background(Color.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testButtonDisabled() {
        let view = Button("Test button\nline 2\nline 3 longer") {}
            .disabled(true)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
