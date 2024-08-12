//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

public import SwiftData

@Model public class QualityV2 {
    // Attributes

    var indicator: String?
    var note: String?
    var title: String?
    var isReversed: Bool = false

    // Relationships

    var project: ProjectV2?

    @Relationship(deleteRule: .cascade)
    var scores: [ScoreV2]?

    public init() {}
}
