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


import UIKit

public struct Animation {

    let animation: CAAnimation

    private init(animation: CAAnimation) {
        self.animation = animation
    }

    public init(duration: TimeInterval,
                type: CATransitionType,
                subtype: CATransitionSubtype? = nil,
                timingFunction: CAMediaTimingFunction? = nil,
                startProgress: Float = 0.0,
                endProgress: Float = 1.0) {
        let animation = CATransition()
        animation.duration = duration
        animation.type = type
        animation.subtype = subtype
        animation.timingFunction = timingFunction
        animation.startProgress = startProgress
        animation.endProgress = endProgress
        self.animation = animation
    }

    public static func custom(_ animation: CAAnimation) -> Animation {
        self.init(animation: animation)
    }
}

public extension Animation {

    static var reveal: Animation {
        return self.reveal()
    }

    static var moveIn: Animation {
        return self.moveIn()
    }

    static var fade: Animation {
        return self.fade()
    }

    static var push: Animation {
        return self.push()
    }

    static func reveal(duration: TimeInterval = 0.2, _ subtype: CATransitionSubtype? = nil) -> Animation {
        return Animation(duration: duration, type: .reveal, subtype: subtype)
    }

    static func moveIn(duration: TimeInterval = 0.2, _ subtype: CATransitionSubtype? = nil) -> Animation {
        return Animation(duration: duration, type: .moveIn, subtype: subtype)
    }

    static func fade(duration: TimeInterval = 0.2, _ subtype: CATransitionSubtype? = nil) -> Animation {
        return Animation(duration: duration, type: .fade, subtype: subtype)
    }

    static func push(duration: TimeInterval = 0.2, _ subtype: CATransitionSubtype? = nil) -> Animation {
        return Animation(duration: duration, type: .push, subtype: subtype)
    }
}

public func withAnimation(_ animation: Animation, on trigger: AnyBinding, content: @escaping () -> View) -> View {
    return trigger.mapToVoid().view(animation: animation, onUpdate: content)
}
