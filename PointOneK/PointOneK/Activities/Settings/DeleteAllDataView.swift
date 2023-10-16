//
//  DeleteAllDataView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 9 Mar 2022.
//

import SwiftUI
import SwiftData

struct DeleteAllDataView: View {
    @State private var enableDeleteButton = false
    @State private var showingDeleteAlert = false

    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) var presentationMode

    @Query() private var projects: [Project]

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
                    presentationMode.wrappedValue.dismiss()
                }

            } label: {
                Text("Delete Everything")
            }
        }
    }
}

struct DeleteAllDataView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DeleteAllDataView()
        }
    }
}
