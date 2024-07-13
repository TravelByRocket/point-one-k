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
            try context.addSampleData()
        }

        return context
    }

    func body(content: Content, context: ModelContext) -> some View {
        content
            .modelContainer(context.container)
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
