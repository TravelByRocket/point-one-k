//
//  Optional+RangeReplaceableCollection+appendSafely.swift
//  PointOneK
//
//  Created by Bryan Costanza on 5/21/24.
//

import Foundation

extension Optional where Wrapped: RangeReplaceableCollection {
    /// Safely appends an element to the collection. If the collection is nil, it will be initialized first.
    /// - Parameter newElement: The element to append to the collection.
    mutating func append(safely newElement: Wrapped.Element) {
        if self == nil {
            self = Wrapped()
        }

        self?.append(newElement)
    }
}
