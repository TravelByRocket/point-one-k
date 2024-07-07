//
//  ProjectTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
@testable import PointOneK
import SwiftData
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

    @MainActor @Test func testCascadeDelete() throws {
        let btc = BaseTestCase()

        let project = ProjectV2()
        let item = ItemV2()
        let quality = QualityV2()
        let score = ScoreV2()

        score.item = item
        score.quality = quality
        item.project = project
        quality.project = project

        btc.context.insert(project)

        #expect((try? btc.context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? btc.context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
        #expect((try? btc.context.fetchCount(FetchDescriptor<ScoreV2>())) == 1)
        #expect((try? btc.context.fetchCount(FetchDescriptor<QualityV2>())) == 1)

        btc.context.delete(project)

        #expect((try? btc.context.fetchCount(FetchDescriptor<ProjectV2>())) == 0)
        #expect((try? btc.context.fetchCount(FetchDescriptor<ItemV2>())) == 0)
        #expect((try? btc.context.fetchCount(FetchDescriptor<ScoreV2>())) == 0)
        #expect((try? btc.context.fetchCount(FetchDescriptor<QualityV2>())) == 0)
    }
}
