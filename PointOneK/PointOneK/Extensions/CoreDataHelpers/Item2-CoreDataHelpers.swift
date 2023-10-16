//
//  Item-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation

extension Item2 {
    enum SortOrder {
        case title, score
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemNote: String {
        note ?? ""
    }

    var itemScores: [Score2] {
        scores ?? []
    }

    var projectQualities: [Quality2] {
        project?.projectQualities ?? []
    }

    var scoreTotal: Int {
        itemScores
            .compactMap { $0.value }
            .map { Int($0) }
            .reduce(0, +)
    }

    static var example: Item2 {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let item = Item2()
        item.title = "My Item"
        item.note = "This is my example note"

        return item
    }

    func hasScore(for quality: Quality2) -> Bool {
        let scoredQualities = itemScores.map { $0.quality }
        return scoredQualities.contains(quality)
    }
}
