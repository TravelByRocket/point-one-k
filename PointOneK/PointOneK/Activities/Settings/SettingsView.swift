//
//  SettingsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10 Dec 2021.
//

import SwiftUI

struct SettingsView: View {
    @State private var enableDeleteButton = false
    @State private var confirmDeletion = false

    var body: some View {
        Form {
            Section {
                Button {
                    //
                } label: {
                    Text("Add $100 Template")
                }
            }
            Section {
                Toggle("Enable \"Delete All\" Option", isOn: $enableDeleteButton)
                Button("Delete All Data") {
                    confirmDeletion = true
                }
                .disabled(!enableDeleteButton)
                .alert("Delete All Data" ,isPresented: $confirmDeletion) {
                    Button(role: .cancel) {
                        //
                    } label: {
                        Text("Cancel")
                    }
                    Button(role: .destructive) {
                        //
                    } label: {
                        Text("Delete All")
                    }
                } message: {
                    Text("summary")
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
