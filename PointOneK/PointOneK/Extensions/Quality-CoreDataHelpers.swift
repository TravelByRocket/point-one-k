//
//  Quality.swift
//  PointOneK
//
//  Created by Bryan Costanza on 28 Nov 2021.
//

import Foundation

extension Quality {
    var qualityTitle: String {
        title ?? "New Quality"
    }

    var qualityNote: String {
        note ?? ""
    }

    var qualityIndicator: String {
        indicator ?? String(qualityTitle.first!) // Text() does not take Character
    }

    var qualityScores: [Score] {
        scores?.allObjects as? [Score] ?? []
    }

    static var example: Quality {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let quality = Quality(context: viewContext)
        quality.title = "Shiny Quality \(Int.random(in: 10...99))"
        quality.note =
        """
        4) Amazing
        3) Great
        2) Good
        1) Acceptable
        """
        quality.indicator = ["a", "h", "r", "q", "n", "k", "y", "m", "w", "x"][Int.random(in: 0...9)]

        return quality
    }

    func score(for item: Item) -> Score? {
        for score in qualityScores where score.item == item {
            return score
        }
        return nil
    }
}
