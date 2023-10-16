//
//  ProjectArchiveDeleteView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectArchiveDeleteSection: View {
    // Private
    @Environment(\.modelContext) private var context
    @Environment(\.presentationMode) private var presentationMode

    // Init
    @State var project: Project
    @State var showingDeleteConfirm = false

    var footer: some View {
        // swiftlint:disable:next line_length
        Text("Closing a project hides a project until it is restored from Settings; deleting it removes the project entirely and permanently.")
    }

    var body: some View {
        Section(footer: footer) {
            Button(project.projectClosed ? "Reopen this project" : "Close this project") {
                project.closed = !project.projectClosed
            }
            .tint(.primary)
            
            Button("Delete this project") {
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

struct ProjectArchiveDeleteSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ProjectArchiveDeleteSection(project: Project.example)
        }
    }
}
