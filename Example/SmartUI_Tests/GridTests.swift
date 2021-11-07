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

class GridTests: XCTestCase {

    func testSimpleVGrid() {
        let view = LazyVGrid {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridWithSpacing() {
        let view = LazyVGrid(spacing: 30) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridManualSized() {
        let view = LazyVGrid(itemsSize: .manual({ _, _ in
            return CGSize(width: 50, height: 50)
        })) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridAlignmentLeading() {
        let view = LazyVGrid(alignment: .leading) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridAlignmentTrailing() {
        let view = LazyVGrid(alignment: .trailing) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridAlignmentCenter() {
        let view = LazyVGrid(alignment: .center) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridAlignmentFill() {
        let view = LazyVGrid(alignment: .fill) {[
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
            Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridWithSections() {
        let view = LazyVGrid {[
            Section(header: Text("Header").background(Color.lightGray),
                    footer: Text("Footer").background(Color.yellow)) {[
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
            ]},
            Section(header: Text("Header").background(Color.lightGray),
                    footer: Text("Footer").background(Color.yellow)) {[
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
            ]}
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridWithSectionsAndPinnedViews() {
        let view = LazyVGrid(pinnedViews: [.sectionHeaders, .sectionFooters]) {[
            Section(header: Text("Header").background(Color.lightGray),
                    footer: Text("Footer").background(Color.yellow)) {[
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
            ]}
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleVGridWithSectionsAndNotPinnedViews() {
        let view = LazyVGrid {[
            Section(header: Text("Header").background(Color.lightGray),
                    footer: Text("Footer").background(Color.yellow)) {[
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100),
                Rectangle().fill(Color.lightGray).frame(width: 100, height: 100)
            ]}
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
