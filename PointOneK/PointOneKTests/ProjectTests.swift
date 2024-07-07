//
//  ProjectTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK
import Testing

struct ProjectTests {
    @Test func testCreatingProjectsAndItems() {
        let btc = BaseTestCase()

        let targetCount = 10
        for _ in 0 ..< targetCount {
            let project = ProjectOld(context: btc.managedObjectContext)

            for _ in 0 ..< targetCount {
                let item = ItemOld(context: btc.managedObjectContext)
                item.project = project
            }
        }

        #expect(btc.dataController.count(for: ProjectOld.fetchRequest()) == targetCount)
        #expect(btc.dataController.count(for: ItemOld.fetchRequest()) == targetCount * targetCount)
    }

    @MainActor @Test func testDeletingProjectCascadeDeleteItems() throws {
        let baseTestCase = BaseTestCase()
        try baseTestCase.dataController.createSampleData()

        let request = NSFetchRequest<ProjectOld>(entityName: "ProjectOld")
        let projects = try baseTestCase.managedObjectContext.fetch(request)
        baseTestCase.dataController.delete(projects[0])

        // 5 - 1 projects
        #expect(baseTestCase.dataController.count(for: ProjectOld.fetchRequest()) == 4)

        // 5 (items/project) * (5 - 1 projects)
        #expect(baseTestCase.dataController.count(for: ItemOld.fetchRequest()) == 20)
    }
}
