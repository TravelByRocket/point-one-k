//
//  Project-ModelHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftData
import SwiftUI

extension ProjectV2 {
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray",
    ]

    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create a new project")
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectItems: [ItemV2] {
        items ?? []
    }

    var projectQualities: [QualityV2] {
        qualities ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

    func addItem(titled title: String? = nil) {
        let item = ItemV2()
        modelContext?.insert(item)
        items = (items ?? []) + [item] // `item.project = self` does not publish change

        if let title {
            item.title = title
        }

        for quality in projectQualities {
            let score = ScoreV2()
            item.scores = (item.scores ?? []) + [score] // score.item = item
            quality.scores = (quality.scores ?? []) + [score] // score.quality = quality
        }
        try? modelContext?.save()
    }

    func addQuality(titled title: String? = nil) {
        let quality = QualityV2()
        modelContext?.insert(quality)
        qualities = (qualities ?? []) + [quality] // `quality.project = self` does not publish change

        if let title {
            quality.title = title
        }

        for item in projectItems {
            let score = ScoreV2()
            item.scores = (item.scores ?? []) + [score] // score.item = item
            quality.scores = (quality.scores ?? []) + [score] // score.quality = quality
        }
        try? modelContext?.save()
    }

    static var example: ProjectV2 {
        let project = ProjectV2()
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true

        let quality = QualityV2()
        quality.title = "Fancy title"
        quality.note = "notes"
        quality.indicator = "a"
        quality.project = project

        let score = ScoreV2()
        score.value = 3
        score.quality = quality

        let item = ItemV2()
        item.project = project
        item.note = "item note"
        item.title = "Sweet Item"

        score.item = item

        return project
    }

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items."
        )
    }

    func projectItems(using sortOrder: ItemV2.SortOrder) -> [ItemV2] {
        switch sortOrder {
        case .title:
            projectItems.sorted(by: \ItemV2.scoreTotal).reversed()
                .sorted(by: \ItemV2.itemTitle.localizedLowercase)
        case .score:
            projectItems.sorted { first, second in
                if first.scoreTotal != second.scoreTotal {
                    first.scoreTotal > second.scoreTotal // larger first
                } else {
                    first.itemTitle.localizedLowercase < second.itemTitle.localizedLowercase // 'a' first
                }
            }
        }
    }
}
