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

class BindingTests: XCTestCase {

    func testBindingCreate() {
        let binding1 = Binding<Int>(value: nil)
        let publisher1 = Publisher<Int>(value: nil)
        XCTAssertNil(binding1.value, "Value must be nil")
        XCTAssertNil(publisher1.value, "Value must be nil")

        let binding2 = Binding<Int>(value: 10)
        let publisher2 = Publisher<Int>(value: 10)
        XCTAssert(binding2.value == 10, "Value must be 10")
        XCTAssert(publisher2.value == 10, "Value must be 10")

        let binding3 = Binding<Int>.create(15)
        let publisher3 = Publisher<Int>.create(15)
        XCTAssert(binding3.value == 15, "Value must be 15")
        XCTAssert(publisher3.value == 15, "Value must be 15")
    }

    func testUpdateValue() {
        let publisher = Publisher<Int>()
        XCTAssertNil(publisher.value, "Publisher created with empty value")

        var updateCounter = 0
        publisher.mapToVoid().bind {
            updateCounter += 1
        }

        publisher.update(1)
        XCTAssert(publisher.value == 1, "The value must be 1")

        publisher.update(2)
        XCTAssert(publisher.value == 2, "The value must be 2")

        publisher.update(3)
        XCTAssert(publisher.value == 3, "The value must be 3")

        XCTAssert(updateCounter == 3, "Updates count must be 3")
    }

    func testMap() {
        let binding = Binding<Int>.create(10).map { "\($0)" }
        XCTAssert(binding.value == "10", "Value must be string 10")

        let publisher = Publisher<Int>.create(10).map { "\($0)" }
        XCTAssert(publisher.value == "10", "Value must be string 10")

        let publisher2 = Publisher<Float>.create(5)
        let binding2 = publisher2.map { $0.description }.map { Int($0)! }.map { $0.description }

        publisher2.update(1)
        publisher2.update(2)
        publisher2.update(3)

        XCTAssert(binding2.value == publisher2.value!.description, "Binding value must be equal to the publisher's but mapped")
    }

    func testCompactMap() {
        let publisher = Publisher<Int>.create(5)
        let binding = publisher
            .compactMap { $0 < 10 ? $0.description : nil }
            .compactMap { Int($0) }
            .compactMap { $0.description }

        var counter1 = 0
        binding.mapToVoid().bind {
            counter1 += 1
        }

        var counter2 = 0
        publisher.mapToVoid().bind {
            counter2 += 1
        }

        publisher.update(1)
        publisher.update(2)
        publisher.update(3)
        publisher.update(20)

        XCTAssert(binding.value == "3", "Binding value must be 3")
        XCTAssert(publisher.value == 20, "Binding value must be 30")
        XCTAssert(counter1 == 3, "Update must be called 3 times for binding")
        XCTAssert(counter2 == 4, "Update must be called 4 times for publisher")
    }

    func testFilter() {
        let publisher = Publisher<Int>.create(10)
        let binding = publisher.filter { $0 > 10 }

        var counter1 = 0
        binding.mapToVoid().bind {
            counter1 += 1
        }

        XCTAssertNil(binding.value, "Binding Value is nil")

        publisher.update(1)
        publisher.update(2)
        publisher.update(3)
        publisher.update(20)
        publisher.update(30)
        publisher.update(3)

        XCTAssert(binding.value == 30, "Binding value must be filtered out")
        XCTAssert(counter1 == 2, "Update must be called 2 times for binding")
    }

    func testCombine() {
        let publisher1 = Publisher<Int>.create(10)
        let publisher2 = Publisher<String>.create("Test")

        let binding = publisher1.combine(publisher2)
        XCTAssert(binding.value?.0 == 10, "Value must be equal to both of the initial ones")
        XCTAssert(binding.value?.1 == "Test", "Value must be equal to both of the initial ones")

        var counter = 0
        binding.mapToVoid().bind {
            counter += 1
        }

        publisher1.update(5)
        XCTAssert(binding.value?.0 == 5)
        XCTAssert(binding.value?.1 == "Test")

        publisher2.update("Hello")
        XCTAssert(binding.value?.0 == 5)
        XCTAssert(binding.value?.1 == "Hello")

        XCTAssert(counter == 2, "Updates count must be 2")
    }

    func testMerge() {
        let publisher1 = Publisher<Int>.create(1)
        let publisher2 = Publisher<Int>.create(2)
        let publisher3 = Publisher<Int>.create(3)

        let binding = Binding.merge(publisher1, publisher2, publisher3)
        XCTAssertNil(binding.value, "Initial value for Merge operation always nil")

        var counter = 0
        binding.mapToVoid().bind {
            counter += 1
        }

        publisher1.update(5)
        XCTAssert(binding.value == 5, "Value must be 5")

        publisher2.update(6)
        XCTAssert(binding.value == 6, "Value must be 6")

        publisher3.update(7)
        XCTAssert(binding.value == 7, "Value must be 7")

        XCTAssert(counter == 3, "Updates count must be 3")
    }

    func testDebounce() {
        let expectation = expectation(description: "Debounce")

        let publisher = Publisher<Int>.create(10)
        let binding = publisher.debounce(for: 0.1)

        var counter = 0
        binding.mapToVoid().bind {
            counter += 1
            expectation.fulfill()
        }

        publisher.update(1)
        publisher.update(2)
        publisher.update(3)
        publisher.update(4)
        publisher.update(5)
        publisher.update(6)

        waitForExpectations(timeout: 0.2, handler: nil)
        XCTAssert(counter == 1, "Updates count must be 1")
        XCTAssert(binding.value == 6, "Value of the bindgin must be 6")
    }
}
