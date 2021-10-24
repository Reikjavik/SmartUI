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

class TextFieldTests: XCTestCase {

    func testSimpleTextField() {
        let view = TextField("Placeholder", text: .create(""))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldWithValue() {
        let view = TextField("Placeholder", text: .create("Test value"))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldWithFont() {
        let view = TextField("Placeholder", text: .create(""))
            .font(.system(size: 16.0, weight: .bold))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldWithPlaceholderColor() {
        let view = TextField("Placeholder", text: .create(""))
            .font(.system(size: 16.0, weight: .bold))
            .placeholderColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldWithColor() {
        let view = TextField("Placeholder", text: .create("Test value"))
            .font(.system(size: 16.0, weight: .bold))
            .placeholderColor(.red)
            .foregroundColor(.blue)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldDisabled() {
        let view = TextField("Placeholder", text: .create("Test value"))
            .font(.system(size: 16.0, weight: .bold))
            .placeholderColor(.red)
            .foregroundColor(.blue)
            .disabled(true)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSecureField() {
        let view = SecureField("Secure Placeholder", text: .create(""))
            .font(.system(size: 16.0, weight: .bold))
            .placeholderColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSecureFieldWithValue() {
        let view = SecureField("Secure Placeholder", text: .create("Some value"))
            .font(.system(size: 16.0, weight: .bold))
            .placeholderColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldAlignmentLeading() {
        let view = TextField("Placeholder", text: .create("Test value"))
            .multilineTextAlignment(.leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldAlignmentTrailing() {
        let view = TextField("Placeholder", text: .create("Test value"))
            .multilineTextAlignment(.trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testTextFieldAlignmentCenter() {
        let view = TextField("Placeholder", text: .create("Test value"))
            .multilineTextAlignment(.center)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
