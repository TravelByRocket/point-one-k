//
//  Score-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import Foundation

extension Score {
    var scoreValue: Int {
        Int(value)
    }

    var scoreItemTitle: String {
        item?.itemTitle ?? "Coalesced Item Title"
    }

    static var example: Score {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let score = Score(context: viewContext)
        score.quality = Quality.example
        score.item = Item.example

        return score
    }
}
