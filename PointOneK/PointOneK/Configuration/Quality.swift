//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class QualityV2 {
    var indicator: String?
    var note: String?
    var title: String?
    var project: ProjectV2?

    @Relationship(deleteRule: .cascade, inverse: \ScoreV2.quality)
    var scores: [ScoreV2]?

    public init() {}
}
