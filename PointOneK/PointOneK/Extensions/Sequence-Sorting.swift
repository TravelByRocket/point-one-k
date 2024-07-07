//
//  Sequence-Sorting.swift
//  PointOneK
//
//  Created by Bryan Costanza on 17 Oct 2021.
//

import Foundation

extension Sequence {
    func sorted<Value>(
        by keyPath: KeyPath<Element, Value>,
        using areInIncreasingOrder: (Value, Value) throws -> Bool
    ) rethrows -> [Element] {
        try sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }

    func sorted(
        by keyPath: KeyPath<Element, some Comparable>
    ) -> [Element] {
        sorted(by: keyPath, using: <)
    }
}
