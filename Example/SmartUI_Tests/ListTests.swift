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

class ListTests: XCTestCase {

    func testSimpleList() {
        let view = List {[
            ProductRow.create(product: .apple),
            ProductRow.create(product: .carrot),
            ProductRow.create(product: .avocado),
            ProductRow.create(product: .apple),
            ProductRow.create(product: .carrot),
            ProductRow.create(product: .avocado),
            ProductRow.create(product: .apple),
            ProductRow.create(product: .carrot)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testSimpleList1Item() {
        let view = List {[
            ProductRow.create(product: .apple)
        ]}
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testConfigurableList() {
        let view = List([.apple, .carrot, .avocado, .apple, .carrot, .avocado, .apple, .carrot]) { product in
            ProductRow.create(product: product)
        }
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testPlainListWithSections() {
        let view = List {[
            Section(
                header: Text("Header").background(Color.lightGray),
                footer: Text("Footer").background(Color.yellow), content: {[
                    ProductRow.create(product: .carrot),
                    ProductRow.create(product: .avocado)
                ]}
            ),
            Section(
                header: Text("Header").background(Color.lightGray),
                footer: Text("Footer").background(Color.yellow), content: {[
                    ProductRow.create(product: .apple),
                    ProductRow.create(product: .carrot)
                ]}
            )
        ]}.listStyle(PlainListStyle())
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }

    func testGroupedListWithSections() {
        let view = List {[
            Section(
                header: Text("Header").background(Color.lightGray),
                footer: Text("Footer").background(Color.yellow), content: {[
                    ProductRow.create(product: .carrot),
                    ProductRow.create(product: .avocado)
                ]}
            ),
            Section(
                header: Text("Header").background(Color.lightGray),
                footer: Text("Footer").background(Color.yellow), content: {[
                    ProductRow.create(product: .apple),
                    ProductRow.create(product: .carrot)
                ]}
            )
        ]}.listStyle(GroupedListStyle())
        let vc = HostingViewController(view: view)
        assertSnapshot(matching: vc, as: .image)
    }
}
