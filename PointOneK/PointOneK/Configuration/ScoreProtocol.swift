//
//  ScoreProtocol.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/23/24.
//

import Foundation

protocol ScoreProtocol {
    associatedtype ItemType
    associatedtype QualityType
    associatedtype IntegerType: FixedWidthInteger

    var value: IntegerType { get }
    var item: ItemType? { get }
    var quality: QualityType? { get }
}
