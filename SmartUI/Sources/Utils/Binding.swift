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

public class Publisher<Value>: Binding<Value> {

    private var debounceTimer: Timer?

    deinit {
        self.stopDebounceTimer()
    }

    public override class func create<Value>(_ value: Value) -> Publisher<Value> {
        return Publisher<Value>(value: value)
    }

    public func update(_ value: Value) {
        self.stopDebounceTimer()
        if self.debounceInterval > 0 {
            let timer = Timer(timeInterval: self.debounceInterval, repeats: false) { [weak self] _ in
                self?.updateValue(value)
            }
            self.debounceTimer = timer
            RunLoop.current.add(timer, forMode: .common)
        } else {
            self.updateValue(value)
        }
    }

    private func updateValue(_ newValue: Value) {
        self.debugName.map {
            $0.isEmpty ?
            print("Update, new value: \(String(describing: newValue))") :
            print($0 + ": Update, new value: \(String(describing: newValue))")
        }
        self.value = newValue
        self.bindings.forEach { $0.execute(newValue) }
    }

    private func stopDebounceTimer() {
        self.debounceTimer?.invalidate()
        self.debounceTimer = nil
    }
}

public class Binding<Value>: AnyBinding {

    fileprivate(set) public var value: Value?
    fileprivate var bindings: [ActionWith<Value>] = []
    fileprivate var debugName: String? = nil
    fileprivate var debounceInterval: TimeInterval = 0.0
    fileprivate var disposeBag: [AnyCancellable] = []

    deinit {
        self.debugName.map { $0.isEmpty ? print("Deinit") : print($0 + ": Deinit" ) }
        self.disposeBag.forEach { $0.cancel() }
    }

    public init(value: Value? = nil) {
        self.value = value
    }

    public class func create<Value>(_ value: Value) -> Binding<Value> {
        return Binding<Value>(value: value)
    }

    internal func bind(_ onChange: ActionWith<Value>) -> AnyCancellable {
        self.debugName.map { $0.isEmpty ? print("Subscribed") : print($0 + ": Subscribed") }
        self.bindings.append(onChange)
        return Disposable { [weak self] in
            self?.bindings.removeAll(where: { $0.id == onChange.id })
        }
    }

    public func bind(_ onChange: @escaping (Value) -> Void) -> AnyCancellable {
        return self.bind(ActionWith<Value>(onChange))
    }

    public func map<C>(_ block: @escaping (Value) -> (C)) -> Binding<C> {
        let newBinding = Publisher<C>(value: self.value.map(block))
        let cancellable = self.bind(ActionWith<Value> { value in
            newBinding.update(block(value))
        })
        self.disposeBag.append(cancellable)
        return newBinding
    }

    public func compactMap<C>(_ block: @escaping (Value) -> (C?)) -> Binding<C> {
        let newBinding = Publisher<C>(value: self.value.flatMap(block))
        let cancellable = self.bind(ActionWith<Value> { value in
            block(value).map { newBinding.update($0) }
        })
        self.disposeBag.append(cancellable)
        return newBinding
    }

    public func mapToVoid() -> Binding<Void> {
        return self.map { _ in }
    }

    public func combine<C>(_ another: Binding<C>) -> Binding<(Value, C)> {
        let newBinding = Publisher<(Value, C)>(value: self.value.with(another.value))
        let cancellable1 = self.bind(ActionWith<Value> { [weak another] value in
            guard let anotherValue = another?.value else { return }
            newBinding.update((value, anotherValue))
        })
        let cancellable2 = another.bind(ActionWith<C> { [weak self] value in
            guard let selfValue = self?.value else { return }
            newBinding.update((selfValue, value))
        })
        self.disposeBag.append(cancellable1)
        self.disposeBag.append(cancellable2)
        return newBinding
    }

    public func filter(_ block: @escaping (Value) -> Bool) -> Binding<Value> {
        let newBinding = Publisher(value: self.value.flatMap { block($0) ? $0 : nil })
        let cancellable = self.bind(ActionWith<Value> {
            block($0) ? newBinding.update($0) : ()
        })
        self.disposeBag.append(cancellable)
        return newBinding
    }

    public func debounce(for seconds: TimeInterval) -> Binding<Value> {
        let newBinding = Publisher(value: self.value)
        newBinding.debounceInterval = seconds
        let cancellable = self.bind(ActionWith<Value> {
            newBinding.update($0)
        })
        self.disposeBag.append(cancellable)
        return newBinding
    }

    public func debug(_ name: String = "") -> Binding<Value> {
        self.debugName = name
        return self
    }

    public func view(placeholder: View = .empty, animation: Animation? = nil, onUpdate: @escaping (Value) -> View) -> View {
        CustomView(view: ContainerView(alignment: .fill) { [weak self] in
            guard let value = self?.value else { return placeholder }
            return onUpdate(value)
        }.redraw(on: self, animation: animation))
    }
}

public protocol AnyBinding {
    func mapToVoid() -> Binding<Void>
}

extension AnyBinding {

    func onChange(_ onChange: Action) -> AnyCancellable {
        self.mapToVoid().bind(onChange)
    }

    func onChange(_ onChange: @escaping () -> Void) -> AnyCancellable {
        self.mapToVoid().bind(onChange)
    }
}

extension Publisher where Value == Void {

    public func update() {
        self.update(())
    }

    public static func create() -> Publisher<Void> {
        return self.create(())
    }
}

// MARK: - Disposing

public protocol AnyCancellable {
    func cancel()
}

public extension AnyCancellable {
    func store(in bag: inout [AnyCancellable]) {
        bag.append(self)
    }
}

class Disposable: AnyCancellable {

    let onCancel: () -> Void

    init(_ onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
    }

    deinit {
        self.onCancel()
    }

    func cancel() {
        self.onCancel()
    }
}
