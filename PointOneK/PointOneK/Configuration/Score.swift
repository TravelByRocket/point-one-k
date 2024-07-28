//
//  Score.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10/16/23.
//
//

import SwiftData

@Model public class ScoreV2 {
    // Attributes

    var value: Int?

    // Relationships

    @Relationship(deleteRule: .nullify)
    var item: ItemV2?

    @Relationship(deleteRule: .nullify)
    var quality: QualityV2?

    public init() {}
}

extension ScoreV2 {
    static var example: ScoreV2 {
        let score = ScoreV2()
        score.quality = QualityV2.example
        score.item = ItemV2.example

        return score
    }
}
