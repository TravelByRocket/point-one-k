//
//  ProjectProtocol.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/23/24.
//

import Foundation

protocol ProjectProtocol {
    associatedtype ItemType
    associatedtype QualityType
    associatedtype ItemSequence: Sequence<ItemType>
    associatedtype QualitySequence: Sequence<QualityType>

    var closed: Bool { get }
    var color: String? { get }
    var detail: String? { get }
    var title: String? { get }
    var items: ItemSequence? { get }
    var qualities: QualitySequence? { get }
}
