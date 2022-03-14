//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI

struct ProjectView: View {
    let project: Project

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

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
        .onDisappear(perform: dataController.save)
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
