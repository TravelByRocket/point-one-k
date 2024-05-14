//
//  DataController-AppLaunched.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import StoreKit
import SwiftUI
import SwiftData

extension DataController {
    func appLaunched() {
        let projectCount = count(for: FetchDescriptor<Project2>())
        let itemCount = (try? modelContext.fetchCount(FetchDescriptor<Item2>())) ?? 0
        guard projectCount >= 5, itemCount <= 10 else { return }

        let hasNeverAsked = dateAskedForReview == nil
        let intervalSinceAsked = dateAskedForReview?.timeIntervalSinceNow ?? 0
        guard hasNeverAsked || intervalSinceAsked > 86400 * 40 else { return }

        let allscenes = UIApplication.shared.connectedScenes
        let scene = allscenes.first

        if let windowScene = scene as? UIWindowScene {
            dateAskedForReview = Date()
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
