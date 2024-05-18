//
//  PointOneKApp.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftData
import SwiftUI

@main
struct PointOneKApp: App {
    @StateObject var dataController: DataController

    init() {
        _dataController = StateObject(wrappedValue: DataController())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Project.self)
    }
}
