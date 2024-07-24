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

struct AnyQuality<ProjectType, ScoreType>: QualityProtocol {
    typealias ScoreSequence = AnySequence<ScoreType>

    let indicator: String?
    let note: String?
    let title: String?
    let isReversed: Bool
    let project: ProjectType?
    let scores: ScoreSequence?

    init<Q: QualityProtocol>(_ quality: Q) where Q.ProjectType == ProjectType, Q.ScoreType == ScoreType {
        indicator = quality.indicator
        note = quality.note
        title = quality.title
        isReversed = quality.isReversed
        project = quality.project
        scores = quality.scores.map { AnySequence($0) }
    }
}
