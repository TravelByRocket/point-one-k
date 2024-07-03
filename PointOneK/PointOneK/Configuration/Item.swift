//
//  Item.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class ItemV2 {
    var note: String?
    var title: String?
    var project: ProjectV2?

    @Relationship(
        deleteRule: .cascade,
        inverse: \ScoreV2.item
    )
    var scores: [ScoreV2]?

    public init() {}
}
