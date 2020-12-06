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

public final class Throttle {
    
    private var timer: Timer?
    private var interval: TimeInterval = 0.0
    private var onComplete: Action = .empty
    
    deinit {
        self.stopTimer()
    }
    
    public init() {}
    
    private func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    public func throttle(_ interval: TimeInterval, onComplete: Action) {
        self.interval = interval
        self.onComplete = onComplete
        self.startTimer()
    }
    
    private func startTimer() {
        self.stopTimer()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: self.interval,
            repeats: false,
            block: { [weak self] _ in
                self?.onComplete.execute()
                self?.timer = nil
            }
        )
    }
}
