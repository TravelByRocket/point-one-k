//
//  QualityProtocol.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/23/24.
//

import Foundation

protocol QualityProtocol {
    associatedtype ProjectType
    associatedtype ScoreType
    associatedtype ScoreSequence: Sequence<ScoreType>

    var indicator: String? { get }
    var note: String? { get }
    var title: String? { get }
    var isReversed: Bool { get }
    var project: ProjectType? { get }
    var scores: ScoreSequence? { get }
}
