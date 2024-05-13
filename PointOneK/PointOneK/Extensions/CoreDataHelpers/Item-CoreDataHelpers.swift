//
//  Item-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation

extension ItemOld {
    enum SortOrder {
        case title, score
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemNote: String {
        note ?? ""
    }

    var itemScores: [ScoreOld] {
        scores?.allObjects as? [ScoreOld] ?? []
    }

    var projectQualities: [QualityOld] {
        project?.projectQualities ?? []
    }

    var scoreTotal: Int {
        Int((itemScores.map(\.value)).reduce(0, +))
    }

    @MainActor
    static var example: ItemOld {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let item = ItemOld(context: viewContext)
        item.title = "My Item"
        item.note = "This is my example note"

        return item
    }

    func hasScore(for quality: QualityOld) -> Bool {
        let scoredQualities = itemScores.map(\.quality)
        return scoredQualities.contains(quality)
    }
}
