//
//  PointOneKApp.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

@main
struct PointOneKApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: ProjectV2.self,
            inMemory: isInMemory
        )
    }

    var isInMemory: Bool {
        #if DEBUG || TESTING
            return true
        #else
            return false
        #endif
    }
}
