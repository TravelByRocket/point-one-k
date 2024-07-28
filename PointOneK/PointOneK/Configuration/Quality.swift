//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class QualityV2 {
    // Attributes

    var indicator: String?
    var note: String?
    var title: String?
    var isReversed: Bool = false

    // Relationships

//    @Relationship(deleteRule: .nullify)
    var project: ProjectV2?

    @Relationship(deleteRule: .cascade)
    var scores: [ScoreV2]?

    public init() {}
}
