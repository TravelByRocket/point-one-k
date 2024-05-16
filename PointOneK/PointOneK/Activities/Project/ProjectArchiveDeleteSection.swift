//
//  ProjectArchiveDeleteSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectArchiveDeleteSection: View {
    var project: Project

    @State private var showingDeleteConfirm = false

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    var footer: some View {
        // swiftlint:disable:next line_length
        Text("Closing a project hides a project until it is restored from Settings; deleting it removes the project entirely and permanently.")
    }

    var body: some View {
        Section(footer: footer) {
            Button(project.closed ?? false ? "Reopen this project" : "Close this project") {
                project.closed?.toggle()
            }

            Button("Delete this project", role: .destructive) {
                showingDeleteConfirm.toggle()
            }
            .tint(.red)
        }
        .alert(isPresented: $showingDeleteConfirm) { getDeleteAlert() }
    }

    func getDeleteAlert() -> Alert {
        Alert(title: Text("Delete project?"),
              // swiftlint:disable:next line_length
              message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."),
              primaryButton: .default(Text("Delete"), action: delete),
              secondaryButton: .cancel())
    }

    func delete() {
        context.delete(project)
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    Form {
        ProjectArchiveDeleteSection(project: .example)
    }
}
