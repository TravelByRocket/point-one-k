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
        @Published var project: ProjectOld
        let dataController: DataController

        @Published var sortOrder = ItemOld.SortOrder.score

        var items: [ItemOld] {
            project.projectItems(using: sortOrder)
        }

        init(project: ProjectOld, dataController: DataController) {
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
