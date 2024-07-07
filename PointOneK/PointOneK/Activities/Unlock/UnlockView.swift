//
//  UnlockView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 15 Mar 2022.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var unlockManager: UnlockManager

    var body: some View {
        VStack {
            switch unlockManager.requestState {
            case let .loaded(product):
                ProductView(product: product)
            case .failed:
                Text("Sorry, there was a error loading the store. Please try again later.")
            case .loading:
                ProgressView("Loading…")
            case .purchased:
                Text("Thank you!")
            case .deferred:
                Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
            }
        }
        .padding()
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }
}

#Preview {
    @Previewable var unlockManager = UnlockManager(dataController: DataController.preview)

    UnlockView()
        .environmentObject(unlockManager)
}
