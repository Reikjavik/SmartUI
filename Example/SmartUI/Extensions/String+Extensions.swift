//
//  String+Extensions.swift
//  SmartUI_Example
//
//  Created by Igor Tiukavkin on 03.10.21.
//  Copyright © 2021 SmartUI. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {

    var isEmpty: Bool {
        switch self {
        case .some(let value):
            return value.isEmpty
        case .none:
            return true
        }
    }
}
