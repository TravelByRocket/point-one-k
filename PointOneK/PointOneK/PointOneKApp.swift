//
//  PointOneKApp.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI
import SwiftData

@main
struct PointOneKApp: App {
    private let allModels: [any PersistentModel.Type] = [Project.self, Item.self, Quality.self, Score.self]

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: allModels)
    }
}
