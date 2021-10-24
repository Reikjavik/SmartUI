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

class ToggleTests: XCTestCase {

    func testSimpleToggleOn() {
        let view = Toggle("Test toggle", isOn: true)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleToggleOff() {
        let view = Toggle("Test toggle", isOn: false)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleWithoutTitle() {
        let view = Toggle(isOn: true)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleLabelsHidden() {
        let view = Toggle(isOn: true).labelsHidden()
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleTint() {
        let view = Toggle(isOn: true).labelsHidden().tint(.purple)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleStyleTint() {
        let view = Toggle(isOn: true)
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: .purple))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleFont() {
        let view = Toggle("Test label", isOn: true)
            .font(.system(size: 14.0, weight: .bold))
            .foregroundColor(.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleMultiline() {
        let view = Toggle("Test label\nline 2\nline 3 longer", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleLineLimit() {
        let view = Toggle("Test label\nline 2\nline 3 longer", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
            .lineLimit(2)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleAlignmentLeading() {
        let view = Toggle("Test label\nline 2\nline 3 longer", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
            .multilineTextAlignment(.leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleAlignmentTrailing() {
        let view = Toggle("Test label\nline 2\nline 3 longer", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
            .multilineTextAlignment(.trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleAlignmentCenter() {
        let view = Toggle("Test label\nline 2\nline 3 longer", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
            .multilineTextAlignment(.center)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleLongText() {
        let view = Toggle("Test label with a very very long text which does not fit to the screen width", isOn: true)
            .font(.system(size: 16.0, weight: .bold))
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomLabel() {
        let view = Toggle(isOn: .create(true)) {
            HStack {[
                Text("Night mode"),
                Text("🌙")
            ]}
        }
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomBigLabel() {
        let view = Toggle(isOn: .create(true)) {
            VStack {[
                Text("Test label with a very very long text which does not fit to the screen width"),
                Text("🌙")
            ]}
            .background(Color.red)
        }
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomBigLabelWithBackground() {
        let view = Toggle(isOn: .create(true)) {
            VStack {[
                Text("Test label with a very very long text which does not fit to the screen width"),
                Text("🌙")
            ]}
        }.background(Color.red)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomBigLabelWithBackgroundAndPadding() {
        let view = Toggle(isOn: .create(true)) {
            VStack {[
                Text("Test label with a very very long text which does not fit to the screen width"),
                Text("🌙")
            ]}
        }
        .background(Color.red)
        .padding(16)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomView() {
        let view = VStack {[
            Text("Title"),
            Toggle("Activate", isOn: true)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleCustomView2() {
        let view = VStack {[
            Text("Turn alarm on?")
                .foregroundColor(.white),
            Toggle(isOn: true).labelsHidden()
        ]}
        .padding(25)
        .background(Color.blue)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10.0)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testToggleDisabled() {
        let view = Toggle("Test toggle", isOn: true)
            .disabled(true)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
