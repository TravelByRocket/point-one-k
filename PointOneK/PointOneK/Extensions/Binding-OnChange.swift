//
//  Binding-OnChange.swift
//  PointOneK
//
//  Created by Bryan Costanza on 3 Oct 2021.
//

import SwiftUI

extension Binding {
    @MainActor
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
