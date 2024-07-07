//
//  Score-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import Foundation

extension ScoreOld {
    var scoreValue: Int {
        Int(value)
    }

    static var example: ScoreOld {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let score = ScoreOld(context: viewContext)
        score.quality = .example
        score.item = .example

        return score
    }
}
