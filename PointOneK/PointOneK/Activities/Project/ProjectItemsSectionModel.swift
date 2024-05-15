//
//  ProjectItemsSectionModel.swift
//  PointOneK
//
//  Created by Bryan Costanza on 14 Mar 2022.
//

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

        @MainActor
        func addItem() {
            objectWillChange.send()
            project.addItem()
            dataController.save()
        }

        @MainActor
        func delete(at offsets: IndexSet, with context: ModelContext) {
            for offset in offsets {
                let item = items[offset]
                dataController.modelContainer.mainContext.delete(item)
            }

            dataController.save()
        }
    }
}
