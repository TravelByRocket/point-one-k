//
//  DataController-AppLaunched.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import SwiftUI
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }
        let hasNeverAsked = dateAskedForReview == nil
        let intervalSinceAsked = dateAskedForReview?.timeIntervalSinceNow ?? 0
        guard hasNeverAsked || intervalSinceAsked > 86_400 * 40 else { return }

        let allscenes = UIApplication.shared.connectedScenes
        let scene = allscenes.first // { $0.activationState == .foregroundActive } // works iff no filtering

        if let windowScene = scene as? UIWindowScene {
            dateAskedForReview = Date()
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
