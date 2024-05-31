//
//  ModelContainer+previewContainer.swift
//  PointOneK
//
//  Created by Bryan Costanza on 5/24/24.
//

import SwiftData

let previewContainer = ModelContainer.previewContainerEmpty

extension ModelContainer {
    static let previewContainerEmpty: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: Project.self, Item.self, Quality.self, Score.self,
                configurations: config
            )

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
