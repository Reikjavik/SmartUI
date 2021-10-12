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

public class Binding<Value>: AnyBinding {

    private(set) public var value: Value?
    private var bindings: [ActionWith<Value>] = []
    private var debugName: String? = nil

    deinit {
        self.debugName.map { $0.isEmpty ? print("Deinit") : print($0 + ": Deinit" ) }
    }

    public init(value: Value? = nil) {
        self.value = value
    }
    
    public static func create<Value>(_ value: Value) -> Binding<Value> {
        return Binding<Value>(value: value)
    }

    public func update(_ value: Value) {
        self.debugName.map {
            $0.isEmpty ?
            print("Update, new value: \(String(describing: value))") :
            print($0 + ": Update, new value: \(String(describing: value))")
        }
        self.value = value
        self.bindings.forEach { $0.execute(value) }
    }

    public func bind(_ onChange: ActionWith<Value>) {
        self.debugName.map { $0.isEmpty ? print("Subscibed") : print($0 + ": Subscibed") }
        self.bindings.append(onChange)
    }

    public func bind(_ onChange: @escaping (Value) -> Void) {
        self.debugName.map { $0.isEmpty ? print("Subscibed") : print($0 + ": Subscibed") }
        self.bindings.append(ActionWith(onChange))
    }

    public func map<C>(_ block: @escaping (Value) -> (C)) -> Binding<C> {
        let newBinding = Binding<C>(value: self.value.map(block))
        self.bind(ActionWith<Value> { value in
            newBinding.update(block(value))
        })
        return newBinding
    }

    public func compactMap<C>(_ block: @escaping (Value) -> (C?)) -> Binding<C> {
        let newBinding = Binding<C>(value: self.value.flatMap(block))
        self.bind(ActionWith<Value> { value in
            block(value).map { newBinding.update($0) }
        })
        return newBinding
    }

    public func mapToVoid() -> Binding<Void> {
        return self.map { _ in }
    }

    public func combine(_ another: Binding<Value>) -> Binding<(Value, Value)> {
        let newBinding = Binding<(Value, Value)>(value: self.value.with(another.value))
        self.bind(ActionWith<Value> { [weak another] value in
            guard let anotherValue = another?.value else { return }
            newBinding.update((value, anotherValue))
        })
        another.bind(ActionWith<Value> { [weak self] value in
            guard let selfValue = self?.value else { return }
            newBinding.update((selfValue, value))
        })
        return newBinding
    }

    public static func merge(_ bindings: Binding<Value>...) -> Binding<Value> {
        let newBinding = Binding<Value>()
        bindings.forEach { binding in
            binding.bind(ActionWith<Value> { value in
                newBinding.update(value)
            })
        }
        return newBinding
    }

    public func filter(_ block: @escaping (Value) -> Bool) -> Binding<Value> {
        let newBinding = Binding(value: self.value.flatMap { block($0) ? $0 : nil })
        self.bind(ActionWith<Value> {
            block($0) ? newBinding.update($0) : ()
        })
        return newBinding
    }

    public func debug(_ name: String = "") -> Binding<Value> {
        self.debugName = name
        return self
    }
}

public protocol AnyBinding {
    func mapToVoid() -> Binding<Void>
}

extension AnyBinding {

    func onChange(_ onChange: Action) {
        self.mapToVoid().bind(onChange)
    }

    func onChange(_ onChange: @escaping () -> Void) {
        self.mapToVoid().bind(onChange)
    }
}

extension Binding where Value == Void {

    public func update() {
        self.update(())
    }

    public static func create() -> Binding<Void> {
        return self.create(())
    }
}
