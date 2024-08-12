//
//  DeleteAllDataView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 9 Mar 2022.
//

import SwiftData
import SwiftUI

struct DeleteAllDataView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var enableDeleteButton = false
    @State private var showingDeleteAlert = false

    @Query
    private var projects: [ProjectV2]

    var body: some View {
        Section(header: Text("Delete All")) {
            Toggle("Allow Data Deletion", isOn: $enableDeleteButton)

            Button("Delete All Data For App") {
                withAnimation {
                    showingDeleteAlert = true
                }
            }
            .disabled(!enableDeleteButton)
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
                for project in projects {
                    context.delete(project)
                }

                withAnimation {
                    showingDeleteAlert = false
                    enableDeleteButton = false
                    dismiss()
                }

            } label: {
                Text("Delete Everything")
            }
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        DeleteAllDataView()
    }
}
