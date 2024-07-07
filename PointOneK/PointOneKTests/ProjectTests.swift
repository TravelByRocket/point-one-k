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
            let project = ProjectOld(context: managedObjectContext)

            for _ in 0 ..< targetCount {
                let item = ItemOld(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: ProjectOld.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: ItemOld.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingProjectCascadeDeleteItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<ProjectOld>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        dataController.delete(projects[0])

        XCTAssertEqual(dataController.count(for: ProjectOld.fetchRequest()), 4) // 5 - 1 projects
        XCTAssertEqual(dataController.count(for: ItemOld.fetchRequest()), 20) // 5 (items/project) * (5 - 1 projects)
    }
}
