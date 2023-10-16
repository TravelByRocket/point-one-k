//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI
import CloudKit

struct ProjectView: View {
    // Private
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @Environment(\.modelContext) private var context

    // Init
    let project: ProjectOld

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

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ProjectView(project: ProjectOld.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
