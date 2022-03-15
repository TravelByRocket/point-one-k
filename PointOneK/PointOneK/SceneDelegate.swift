//
//  SceneDelegate.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    @Environment(\.openURL) var openURL

    // for opening the app cold
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
            if let shortcutItem = connectionOptions.shortcutItem {
                guard let url = URL(string: shortcutItem.type) else {
                    return
                }

                openURL(url)
            }
    }

    // for when the scene already exists
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void) {
            guard let url = URL(string: shortcutItem.type) else {
                completionHandler(false)
                return
            }

            openURL(url, completion: completionHandler)
    }
}
