//
//  ProjectTests.swift
//  PointOneKTests
//
//  Created by Bryan Costanza on 27 Nov 2021.
//

import CoreData
import SwiftData
import Testing

@testable import PointOneK

final class ProjectTests: BaseTestCase {
    @Test func testCreatingProjectsAndItems() {
        let targetCount = 10
        for _ in 0 ..< targetCount {
            let project = ProjectOld(context: managedObjectContext)

            for _ in 0 ..< targetCount {
                let item = ItemOld(context: managedObjectContext)
                item.project = project
            }
        }

        #expect(dataController.count(for: ProjectOld.fetchRequest()) == targetCount)
        #expect(dataController.count(for: ItemOld.fetchRequest()) == targetCount * targetCount)
    }

    @MainActor @Test func testDeletingProjectCascadeDeleteItems() throws {
        try? dataController.createSampleData()

        let request = NSFetchRequest<ProjectOld>(entityName: "ProjectOld")
        let projects = try managedObjectContext.fetch(request)
        dataController.delete(projects[0])

        // 5 - 1 projects
        #expect(dataController.count(for: ProjectOld.fetchRequest()) == 4)

        // 5 (items/project) * (5 - 1 projects)
        #expect(dataController.count(for: ItemOld.fetchRequest()) == 20)
    }

    @MainActor @Test func testCascadeDelete() throws {
        let project = ProjectV2()
        let item = ItemV2()
        let quality = QualityV2()
        let score = ScoreV2()

        score.item = item
        score.quality = quality
        item.project = project
        quality.project = project

        context.insert(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 1)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 1)

        context.delete(project)

        #expect((try? context.fetchCount(FetchDescriptor<ProjectV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<ItemV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<ScoreV2>())) == 0)
        #expect((try? context.fetchCount(FetchDescriptor<QualityV2>())) == 0)
    }
}
