//
//  Collection+Extensions.swift
//  SmartUI
//
//  Created by Igor Tiukavkin on 17.10.21.
//

import Foundation

extension Array where Element: Hashable {

    func distinct() -> [Element] {
        return self.reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
    }
}

extension Array {

    func distinct(where condition: ([Element], Element) -> Bool) -> [Element] {
        return self.reduce([], { condition($0, $1) ? $0 : $0 + [$1] })
    }
}
