//
//  Item.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

public import SwiftData

@Model public class ItemV2 {
    // Attributes

    var note: String?
    var title: String?

    // Relationships

    var project: ProjectV2?

    @Relationship(deleteRule: .cascade)
    var scores: [ScoreV2]?

    public init() {}
}
