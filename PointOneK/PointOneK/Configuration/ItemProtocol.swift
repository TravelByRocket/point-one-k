//
//  ItemProtocol.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/23/24.
//

import Foundation

protocol ItemProtocol {
    associatedtype ProjectType
    associatedtype ScoreType
    associatedtype ScoreSequence: Sequence<ScoreType>

    var note: String? { get }
    var title: String? { get }
    var project: ProjectType? { get }
    var scores: ScoreSequence? { get }
}
