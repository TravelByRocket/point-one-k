//
//  ProjectArchiveDeleteSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectArchiveDeleteSection: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var showingDeleteConfirm = false

    @Bindable var project: Project

    var body: some View {
        Section(footer: footer) {
            Button(project.closed ? "Reopen this project" : "Close this project") {
                project.closed.toggle()
            }
            .tint(.primary)

            Button("Delete this project", role: .destructive) {
                showingDeleteConfirm.toggle()
            }
            .tint(.red)
        }
        .alert(isPresented: $showingDeleteConfirm) { deleteAlert }
    }

    var footer: some View {
        // swiftlint:disable:next line_length
        Text("Closing a project hides a project until it is restored from Settings; deleting it removes the project entirely and permanently.")
    }

    var deleteAlert: Alert {
        Alert(title: Text("Delete project?"),
              // swiftlint:disable:next line_length
              message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
              primaryButton: .default(Text("Delete"), action: delete),
              secondaryButton: .cancel())
    }

    func delete() {
        context.delete(project)
        dismiss()
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    Form {
        ProjectArchiveDeleteSection(project: .example)
    }
}
