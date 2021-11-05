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

class SliderTests: XCTestCase {

    func testSimpleSlider() {
        let view = Slider(value: .create(10), in: (0...100), step: 10)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderWithoutValue() {
        let view = Slider(value: .create(0), in: (0...100), step: 10)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderFullValue() {
        let view = Slider(value: .create(100), in: (0...100), step: 10)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderWithLabel() {
        let view = Slider(value: .create(50), in: (0...100), step: 10, label: {
            Text("Label")
                .multilineTextAlignment(.leading)
                .frame(width: .infinity)
                .padding()
        })
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderWithLabelAndMinValue() {
        let view = Slider(value: .create(50), in: (0...100), step: 10, label: {
            Text("Label")
                .multilineTextAlignment(.leading)
                .frame(width: .infinity)
                .padding()
        }, minimumValueLabel: {
            Text("Minimum").padding()
        })
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderWithLabelAndMinAndMaxValue() {
        let view = Slider(value: .create(50), in: (0...100), step: 10, label: {
            Text("Label")
                .multilineTextAlignment(.leading)
                .frame(width: .infinity)
                .padding()
        }, minimumValueLabel: {
            Text("Minimum").padding()
        }, maximumValueLabel: {
            Text("Max")
                .font(.boldSystemFont(ofSize: 14))
        })
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleSliderWithLabelAndMinAndMaxValueAndPadding() {
        let view = Slider(value: .create(50), in: (0...100), step: 10, label: {
            Text("Label")
                .multilineTextAlignment(.leading)
                .frame(width: .infinity)
                .padding()
        }, minimumValueLabel: {
            Text("Minimum").padding()
        }, maximumValueLabel: {
            Text("Max")
                .font(.boldSystemFont(ofSize: 14))
        }).padding(16)
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

}
