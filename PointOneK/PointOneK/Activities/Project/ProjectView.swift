//
//  ProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import CloudKit
import SwiftUI

struct ProjectView: View {
    let project: Project

    var body: some View {
        Form {
            ProjectTitleEditView(project: project)

            Section(header: Text("Description")) {
                ProjectDetailEditView(project: project)
            }

            ProjectItemsSection(project: project)

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
    .modelContainer(previewContainer)
}
