// MIT License
//
// Copyright (c) 2020 Igor Tiukavkin.
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

import Foundation

public typealias Action = ActionWith<Void>

public struct ActionWith<T> {

    private let block: (T) -> Void

    public init(_ block: @escaping (T) -> Void) {
        self.block = block
    }

    public func execute(_ value: T, delay: TimeInterval = 0.0) {
        if delay > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.block(value)
            }
        } else {
            self.block(value)
        }
    }

    public func map<C>(_ block: @escaping (C) -> (T)) -> ActionWith<C> {
        return ActionWith<C> { value in
            self.execute(block(value))
        }
    }

    public func flatMap<C>(_ block: @escaping (C) -> (T?)) -> ActionWith<C> {
        return ActionWith<C> { value in
            block(value).map { self.execute($0) }
        }
    }
}

public extension Action {

    func adapt<T>() -> ActionWith<T> {
        return self.map({ _ in })
    }

    func execute(delay: TimeInterval = 0.0) {
        self.execute((), delay: delay)
    }
}

public extension ActionWith {

    static var empty: ActionWith<T> {
        return ActionWith { _ in }
    }

    static func merge(_ actions: Self?...) -> Self {
        return Self { value in
            actions.forEach { $0?.execute(value) }
        }
    }

    func combine(_ action: Self?) -> Self {
        return Self.merge(self, action)
    }
}
