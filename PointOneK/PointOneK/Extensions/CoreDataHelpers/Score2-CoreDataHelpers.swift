//
//  Score-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import Foundation

extension Score2 {
    var scoreValue: Int {
        Int(value ?? 0)
    }

    static var example: Score2 {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let score = Score2()
        score.quality = Quality2.example
        score.item = Item2.example

        return score
    }
}
