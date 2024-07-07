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
    typealias Context = (container: ModelContainer, dataController: DataController)

    static func makeSharedContext() throws -> Context {
        try (
            ModelContainer(for: ProjectV2.self),
            DataController.preview
        )
    }

    func body(content: Content, context: Context) -> some View {
        content
            .modelContainer(context.container)
            .environment(\.managedObjectContext, context.dataController.container.viewContext)
            .environmentObject(context.dataController)
    }
}

extension PreviewModifier where Self == PersistenceLayerPreviewModifier {
    @MainActor static var persistenceLayer: some PreviewModifier { PersistenceLayerPreviewModifier() }
}
