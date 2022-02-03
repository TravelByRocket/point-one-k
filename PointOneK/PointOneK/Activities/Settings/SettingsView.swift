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

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        Form {
            Section {
                Button {
                    let project = Project(context: managedObjectContext)
                    project.title = "$100 Startup Ideas"
//                    for title in ["Ease", "Profitability", "Vision", "Impact"] {
//
//                    }
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
                .alert("Delete All Data", isPresented: $confirmDeletion) {
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
    static var dataController = DataController.preview

    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
