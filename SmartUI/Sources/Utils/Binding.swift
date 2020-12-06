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

public class Binding<Value> {

    private(set) public var value: Value
    private var bindings: [ActionWith<Value>] = []

    public init(value: Value) {
        self.value = value
    }

    public static func constant<Value>(_ value: Value) -> Binding<Value> {
        return Binding<Value>(value: value)
    }
    
    public static func create<Value>(_ value: Value) -> Binding<Value> {
        return Binding<Value>(value: value)
    }

    public func update(_ value: Value) {
        self.value = value
        self.bindings.forEach { $0.execute(value) }
    }

    public func bind(_ onChange: ActionWith<Value>, getInitial: Bool = false) {
        self.bindings.append(onChange)
        guard getInitial else { return }
        onChange.execute(self.value)
    }

    public func map<C>(_ block: @escaping (Value) -> (C)) -> Binding<C> {
        let newBinding = Binding<C>(value: block(self.value))
        self.bind(ActionWith<Value> { value in
            newBinding.update(block(value))
        })
        return newBinding
    }

    public func mapToVoid() -> Binding<Void> {
        return self.map({ _ in })
    }

    public func combine(_ another: Binding<Value>) -> Binding<(Value, Value)> {
        let newBinding = Binding<(Value, Value)>(value: (self.value, another.value))
        self.bind(ActionWith<Value> { [weak another] value in
            guard let another = another else { return }
            newBinding.update((value, another.value))
        })
        another.bind(ActionWith<Value> { [weak self] value in
            guard let self = self else { return }
            newBinding.update((self.value, value))
        })
        return newBinding
    }

    public static func merge(_ bindings: Binding<Value>...) -> Binding<Value> {
        let newBinding = Binding<Value>(value: bindings.first!.value)
        bindings.forEach { binding in
            binding.bind(ActionWith<Value> { value in
                newBinding.update(value)
            })
        }
        return newBinding
    }
}
