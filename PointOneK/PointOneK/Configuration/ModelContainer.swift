//
//  ModelContainer.swift
//  PointOneK
//
//  Created by Bryan Costanza on 8/5/24.
//

import SwiftData

extension ModelContainer {
    static var standard: ModelContainer {
        #if DEBUG
            let config = ModelConfiguration(
                "debug",
                isStoredInMemoryOnly: false,
                groupContainer: .automatic
            )
        #else
            let config = ModelConfiguration(
                isStoredInMemoryOnly: false,
                groupContainer: .automatic
            )
        #endif

        let container = try! ModelContainer(
            for: ProjectV2.self,
            configurations: config
        )

        return container
    }
}
