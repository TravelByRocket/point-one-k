//
//  PersistenceLayerPreviewModifier.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/7/24.
//

import CoreData
import SwiftData
import SwiftUI

struct PersistenceLayerPreviewModifier: PreviewModifier {
    static var useSampleData: Bool = false

    init(useSampleData: Bool = true) {
        Self.useSampleData = useSampleData
    }

    static func makeSharedContext() async throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ProjectV2.self, configurations: config)
        let context = ModelContext(container)

        if useSampleData {
            try addSampleData(context: context)
        }

        return context
    }

    var dataController = DataController(inMemory: true)

    func body(content: Content, context: ModelContext) -> some View {
        content
            .modelContainer(context.container)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

extension PreviewModifier where Self == PersistenceLayerPreviewModifier {
    @MainActor static var persistenceLayer: some PreviewModifier {
        PersistenceLayerPreviewModifier(useSampleData: false)
    }

    @MainActor static var persistenceLayerPopulated: some PreviewModifier {
        PersistenceLayerPreviewModifier(useSampleData: true)
    }
}

extension PersistenceLayerPreviewModifier {
    static func addSampleData(context: ModelContext) throws {
        // PROJECTS
        for projectCounter in 1 ... 3 {
            let project = ProjectV2()
            project.title = "Project \(projectCounter)"
            project.items = []
            project.closed = false
            project.detail = "Nothing in particular \(Int16.random(in: 1_000 ... 9_999))"

            // QUALITIES
            for qualityCounter in 1 ... 3 {
                let quality = QualityV2()
                quality.title = "Quality \(qualityCounter)"
                quality.note = "Description \(Int.random(in: 1_000 ... 9_999))"
                quality.project = project
            }

            // ITEMS
            for itemCounter in 1 ... 3 {
                let item = ItemV2()
                item.title = "Item \(itemCounter)"
                item.project = project

                // QUALITIES <-> SCORES
                for quality in project.qualities ?? [] {
                    let score = ScoreV2()
                    score.item = item
                    score.quality = quality
                    score.value = Int.random(in: 1 ... 4)
                }
            }

            context.insert(project)
        }
    }
}
