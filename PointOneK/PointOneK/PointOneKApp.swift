//
//  PointOneKApp.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

@main
struct PointOneKApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var dataController: DataController

    init() {
        _dataController = StateObject(wrappedValue: DataController())
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(
                    // Automatically save when no longer in the foreground. Use this over scene phase API for port to
                    // macOS (as of macOS 11.1)
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
                .onAppear(perform: dataController.appLaunched)
        }
    }

    func save(note _: Notification) {
        dataController.save()
    }
}
