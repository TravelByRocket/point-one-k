//
//  Project-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import CloudKit
import SwiftUI

extension ProjectOld {
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

    var projectItems: [ItemOld] {
        items?.allObjects as? [ItemOld] ?? []
    }

    var projectQualities: [QualityOld] {
        qualities?.allObjects as? [QualityOld] ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

    func addItem(titled title: String? = nil) {
        guard let moc = managedObjectContext else { return }

        let item = ItemOld(context: moc)
        item.project = self

        if let title {
            item.title = title
        }

        for quality in projectQualities {
            let score = ScoreOld(context: moc)
            score.item = item
            score.quality = quality
        }
    }

    func addQuality() {
        guard let moc = managedObjectContext else { return }

        let quality = QualityOld(context: moc)
        quality.project = self
        for item in projectItems {
            let score = ScoreOld(context: moc)
            score.item = item
            score.quality = quality
        }
    }

    static var example: ProjectOld {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let project = ProjectOld(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = true

        let quality = QualityOld(context: viewContext)
        quality.title = "Fancy title"
        quality.note = "notes"
        quality.indicator = "a"
        quality.project = project

        let score = ScoreOld(context: viewContext)
        score.value = 3
        score.quality = quality

        let item = ItemOld(context: viewContext)
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

    func projectItems(using sortOrder: ItemOld.SortOrder) -> [ItemOld] {
        switch sortOrder {
        case .title:
            projectItems.sorted(by: \ItemOld.scoreTotal).reversed()
                .sorted(by: \ItemOld.itemTitle.localizedLowercase)
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
