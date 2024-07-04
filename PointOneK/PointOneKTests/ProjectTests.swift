//
//  ProjectTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK
import XCTest

class ProjectTests: BaseTestCase {
    func testCreatingProjectsAndItems() {
        let targetCount = 10
        for _ in 0 ..< targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0 ..< targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeleteItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4) // 5 - 1 projects
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 20) // 5 (items/project) * (5 - 1 projects)
    }
}
