//
//  Score-ModelHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import Foundation

extension Score {
    var scoreValue: Int {
        Int(value ?? 0)
    }

    @MainActor
    static var example: Score {
        let container = DataController.previewContainer

        let score = Score()
        score.quality = Quality.example
        score.item = Item.example

        container.mainContext.insert(score)

        return score
    }
}
