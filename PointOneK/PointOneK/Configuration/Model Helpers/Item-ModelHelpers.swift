//
//  Item-ModelHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation

extension ItemV2 {
    enum SortOrder {
        case title, score
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemNote: String {
        note ?? ""
    }

    var itemScores: [ScoreV2] {
        scores ?? []
    }

    var projectQualities: [QualityV2] {
        project?.projectQualities ?? []
    }

    var scoreTotal: Int {
        itemScores
            .compactMap(\.value)
            .map { Int($0) }
            .reduce(0, +)
    }

    static var example: ItemV2 {
        let item = ItemV2()
        item.title = "My Item"
        item.note = "This is my example note"

        return item
    }

    func hasScore(for quality: QualityV2) -> Bool {
        let scoredQualities = itemScores.map(\.quality)
        return scoredQualities.contains(quality)
    }
}
