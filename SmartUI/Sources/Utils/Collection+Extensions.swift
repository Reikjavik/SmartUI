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

extension Array where Element: Identifiable {

    func distinct() -> [Element] {
        self.distinct(where: { all, item in all.contains(where: { $0.id == item.id }) })
    }
}

extension Array {

    func distinct(where isDuplicate: ([Element], Element) -> Bool) -> [Element] {
        return self.reduce([], { isDuplicate($0, $1) ? $0 : $0 + [$1] })
    }

    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
}
