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
    private let allModels: [any PersistentModel.Type] = [Project2.self, Item2.self, Quality2.self, Score2.self]
    
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onAppear(perform: dataController.appLaunched)
        }
        .modelContainer(for: allModels)
    }

    func save(note: Notification) {
        dataController.save()
    }
}
