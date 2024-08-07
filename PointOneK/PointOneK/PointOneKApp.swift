//
//  PointOneKApp.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

typealias Project = ProjectV2
typealias Item = ItemV2
typealias Quality = QualityV2
typealias Score = ScoreV2

@main
struct PointOneKApp: App {
    init() {
        let env = ProcessInfo.processInfo.environment
        if env["DISABLE_ANIMATIONS"] == "true" {
            UIView.setAnimationsEnabled(false)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(.standard)
    }
}
