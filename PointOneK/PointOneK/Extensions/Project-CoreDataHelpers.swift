//
//  Project-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation
import SwiftUI

extension Project {
    static let colors = [
        "Pink", "Purple", "Red", "Orange", "Gold",
        "Green", "Teal", "Light Blue", "Dark Blue",
        "Midnight", "Dark Gray", "Gray"]

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
        items?.allObjects as? [Item] ?? []
    }

    var projectQualities: [Quality] {
        qualities?.allObjects as? [Quality] ?? []
    }

    var scorePossible: Int {
        projectQualities.count * 4
    }

    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted {first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.itemTitle < second.itemTitle

        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else {
            return 0
        }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    static var example: Project {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.closed = false

        let quality = Quality(context: viewContext)
        quality.title = "Fancy title"
        quality.note = "notes"
        quality.indicator = "a"
        quality.project = project

        let score = Score(context: viewContext)
        score.value = 3
        score.quality = quality

        let item = Item(context: viewContext)
        item.project = project
        item.note = "item note"
        item.title = "Sweet Item"
        item.completed = false

        score.item = item

        return project
    }

    var label: LocalizedStringKey {
        LocalizedStringKey(
            "\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%d")% complete."
        )
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .optimized:
            return projectItemsDefaultSorted
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        }
    }
}
