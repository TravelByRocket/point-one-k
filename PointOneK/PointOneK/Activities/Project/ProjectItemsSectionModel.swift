//
//  ProjectItemsSectionModel.swift
//  PointOneK
//
//  Created by Bryan Costanza on 14 Mar 2022.
//

import Foundation
import CoreData

extension ProjectItemsSection {
    class ViewModel: ObservableObject {
        @Published var project: Project
        let dataController: DataController

        @Published var sortOrder = Item.SortOrder.score

        var items: [Item] {
            project.projectItems(using: sortOrder)
        }

        init(project: Project, dataController: DataController) {
            self.project = project
            self.dataController = dataController
        }

        func toggleSortOrder() {
            if sortOrder == .title {
                sortOrder = .score
            } else { // if sortOrder == .score
                sortOrder = .title
            }
        }

        func addItem() {
            objectWillChange.send()
            project.addItem()
            dataController.save()
        }

        func delete(at offsets: IndexSet) {
            for offset in offsets {
                let item = items[offset]
                dataController.delete(item)
            }
            objectWillChange.send()
            dataController.save()
        }
    }
}
