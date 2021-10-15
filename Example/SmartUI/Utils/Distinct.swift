//
//  Distinct.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 03.10.21.
//  Copyright © 2021 SmartUI. All rights reserved.
//

import Foundation

public final class Distinct<T: Equatable> {

    private var previous: T?
    
    public init() {}

    public func distinct(value: T, block: () -> Void) {
        guard value != previous else { return }
        self.previous = value
        block()
    }
}
