//
//  Project-ModelHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import CloudKit
import SwiftUI
import SwiftData

extension Project {
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

    var projectItems: [Item] {
        items ?? []
    }

    var projectQualities: [Quality] {
        qualities ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

    func addItem(titled title: String? = nil, in context: ModelContext) {
        let item = Item()
        context.insert(item)
        items.append(safely: item)

        if let title {
            item.title = title
        }

        for quality in projectQualities {
            let score = Score()
            score.item = item
            score.quality = quality
            context.insert(score)
        }

//        try? modelContext?.save()
    }

    func addQuality(in context: ModelContext) {
        let quality = Quality()
        context.insert(quality)
        qualities.append(safely: quality)

        for item in projectItems {
            let score = Score()
            score.item = item
            score.quality = quality
            context.insert(score)
        }
    }

    static var example: Project {
        let project = Project()
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true

        let quality = Quality()
        quality.title = "Fancy title"
        quality.note = "notes"
        quality.indicator = "a"
        quality.project = project

        let score = Score()
        score.value = 3
        score.quality = quality

        let item = Item()
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

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            projectItems.sorted(by: \Item.scoreTotal).reversed()
                .sorted(by: \Item.itemTitle.localizedLowercase)
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