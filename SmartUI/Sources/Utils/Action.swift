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

internal typealias Action = ActionWith<Void>

internal struct ActionWith<T> {

    private let block: (T) -> Void

    internal init?(_ block: ((T) -> Void)?) {
        if let block = block {
            self.block = block
        } else {
            return nil
        }
    }

    internal init(_ block: @escaping (T) -> Void) {
        self.block = block
    }

    internal func execute(_ value: T, delay: TimeInterval = 0.0) {
        if delay > 0.0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.block(value)
            }
        } else {
            self.block(value)
        }
    }

    internal func map<C>(_ block: @escaping (C) -> (T)) -> ActionWith<C> {
        return ActionWith<C> { value in
            self.execute(block(value))
        }
    }

    internal func compactMap<C>(_ block: @escaping (C) -> (T?)) -> ActionWith<C> {
        return ActionWith<C> { value in
            block(value).map { self.execute($0) }
        }
    }
}

internal extension Action {

    func adapt<T>() -> ActionWith<T> {
        return self.map({ _ in })
    }

    func execute(delay: TimeInterval = 0.0) {
        self.execute((), delay: delay)
    }
}

internal extension ActionWith {

    static var empty: ActionWith<T> {
        return ActionWith { _ in }
    }

    static func merge(_ actions: Self?...) -> Self {
        return Self { value in
            actions.forEach { $0?.execute(value) }
        }
    }

    func merge(_ action: Self?) -> Self {
        return Self.merge(self, action)
    }

    func combine<U>(_ another: ActionWith<U>) -> ActionWith<(T, U)> {
        return .init {
            self.execute($0)
            another.execute($1)
        }
    }
}
