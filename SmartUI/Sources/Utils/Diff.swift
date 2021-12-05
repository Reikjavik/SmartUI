//
//  Diff.swift
//  SmartUI
//
//  Created by Igor Tiukavkin on 17.10.21.
//

import Foundation

struct Diff<T: Equatable> {
    let common: [(Int, T)]
    let deleted: [(Int, T)]
    let inserted: [(Int, T)]

    var hasUpdates: Bool {
        return deleted.count > 0 || inserted.count > 0
    }

    init(_ left: [T], _ right: [T]) {
        self.common = left.filter { right.contains($0) }.map { (left.firstIndex(of: $0)!, $0) }
        self.inserted = right.filter { !left.contains($0) }.map { (right.firstIndex(of: $0)!, $0) }
        self.deleted = left.filter { !right.contains($0) }.map { (left.firstIndex(of: $0)!, $0) }
    }
}
