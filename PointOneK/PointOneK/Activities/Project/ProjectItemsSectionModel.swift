//
//  ProjectItemsSectionModel.swift
//  PointOneK
//
//  Created by Bryan Costanza on 14 Mar 2022.
//

import CoreData
import Foundation

extension ProjectItemsSection {
    class ViewModel: ObservableObject {
        @Published var project: Project2
        let dataController: DataController

        @Published var sortOrder = Item2.SortOrder.score

        var items: [Item2] {
            project.projectItems(using: sortOrder)
        }

        init(project: Project2, dataController: DataController) {
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

        func delete(at offsets: IndexSet, with context: ModelContext) {
            for offset in offsets {
                let item = items[offset]
                context.delete(item)
                #warning("delete not enabled")
            }
            objectWillChange.send()
            dataController.save()
        }
    }
}
