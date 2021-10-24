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

class GradientTests: XCTestCase {

    func testGradientTopBottom() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .top, endPoint: .bottom)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientBottomTop() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .bottom, endPoint: .top)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientLeadingTrailing() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientTrailingLeading() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .trailing, endPoint: .leading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientTopLeadingBottomTrailing() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientTopTrailingBottomLeading() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue]), startPoint: .topTrailing, endPoint: .bottomLeading)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientWith3Colors() {
        let view = LinearGradient(gradient: .init(colors: [.red, .blue, .yellow]), startPoint: .top, endPoint: .bottom)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientWith3ColorsInit() {
        let view = LinearGradient(colors: [.red, .blue, .yellow], startPoint: .top, endPoint: .bottom)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGradientWithStops() {
        let view = LinearGradient(stops:[
            .init(color: .red, location: 0.1),
            .init(color: .yellow, location: 0.6),
            .init(color: .blue, location: 0.3)
        ], startPoint: .top, endPoint: .bottom)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
