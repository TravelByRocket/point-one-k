//
//  Item-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemNote: String {
        note ?? ""
    }

    var itemScores: [Score] {
        scores?.allObjects as? [Score] ?? []
    }

    var projectQualities: [Quality] {
        project?.projectQualities ?? []
    }

    var scoreTotal: Int {
        Int((itemScores.map {$0.value}).reduce(0, +))
    }

    static var example: Item {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let item = Item(context: viewContext)
        item.title = "My Item"
        item.note = "This is my note"
        item.completed = false
        item.priority = 2

        return item
    }

    func hasScore(for quality: Quality) -> Bool {
        let scoredQualities = itemScores.map { $0.quality }
        return scoredQualities.contains(quality)
    }
}
