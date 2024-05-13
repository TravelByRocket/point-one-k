//
//  ProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import CloudKit
import SwiftUI

struct ProjectView: View {
    // Private
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.modelContext) private var context

    // Init
    let project: Project2

    var body: some View {
        Form {
            ProjectTitleEditView(project: project)
            Section(header: Text("Description")) {
                ProjectDetailEditView(project: project)
            }
            ProjectItemsSection(project: project, dataController: dataController)
            ProjectQualitiesSection(project: project)
            ProjectColorSelectionSection(project: project)
            ProjectArchiveDeleteSection(project: project)
        }
        .navigationTitle("Edit Project")
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationView {
        ProjectView(project: .example)
    }
}
