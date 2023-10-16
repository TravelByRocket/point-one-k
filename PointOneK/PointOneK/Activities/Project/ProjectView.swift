//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI
import CloudKit

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

struct ProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.example)
        }
    }
}
