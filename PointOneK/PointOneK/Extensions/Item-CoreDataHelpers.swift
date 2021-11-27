//
//  Item-CoreDataHelpers.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import Foundation

extension Item {
    enum SortOrder {
        case optimized, title, creationDate
    }

    var itemTitle: String {
        title ?? NSLocalizedString("New Item", comment: "Create a new item")
    }

    var itemNote: String {
        note ?? ""
    }

    var itemCreationDate: Date {
        creationDate ?? Date()
    }

    static var example: Item {
        let dataController = DataController.preview
        let viewContext = dataController.container.viewContext

        let item = Item(context: viewContext)
        item.title = "My Item"
        item.note = "This is my note"
        item.completed = false
        item.creationDate = Date()
        item.priority = 2

        return item
    }
}
