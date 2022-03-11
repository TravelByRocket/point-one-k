//
//  DeleteAllDataView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 9 Mar 2022.
//

import SwiftUI

struct DeleteAllDataView: View {
    @State private var enableDeleteButton = false
    @State private var showingDeleteAlert = false

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        List {
            Section(header: Text("Delete All")) {
                Toggle("Allow Data Deletion", isOn: $enableDeleteButton)
                Button("Delete All Data For App") {
                    withAnimation {
                        showingDeleteAlert = true
                    }
                }
                .disabled(!enableDeleteButton)
            }
        }
        .alert("Delete All Data?", isPresented: $showingDeleteAlert) {
            Button(role: .cancel) {
                withAnimation {
                    showingDeleteAlert = false
                    enableDeleteButton = false
                }
            } label: {
                Text("Cancel")
                    .tint(.blue)
            }
            Button(role: .destructive) {
                dataController.deleteAll()
                withAnimation {
                    showingDeleteAlert = false
                    enableDeleteButton = false
                }
            } label: {
                Text("Delete Everything")
            }
        }
    }
}

struct DeleteAllDataView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        DeleteAllDataView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
