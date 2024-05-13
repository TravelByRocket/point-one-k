//
//  Score2-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import Foundation

extension Score2 {
    var scoreValue: Int {
        Int(value ?? 0)
    }

    @MainActor
    static var example: Score2 {
        let container = DataController.previewContainer

        let score = Score2()
        score.quality = Quality2.example
        score.item = Item2.example

        container.mainContext.insert(score)

        return score
    }
}
