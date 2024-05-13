//
//  DataController-AppLaunched.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import StoreKit
import SwiftUI

extension DataController {
    func appLaunched() {
        guard count(for: ProjectOld.fetchRequest()) >= 5 else { return }
        guard count(for: ItemOld.fetchRequest()) >= 10 else { return }

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
