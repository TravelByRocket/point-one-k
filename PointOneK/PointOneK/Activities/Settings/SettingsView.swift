//
//  SettingsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10 Dec 2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest var closedProjects: FetchedResults<Project>
    @FetchRequest var openProjects: FetchedResults<Project>

    var noProjectsText: some View {
        Text("No projects here")
            .font(.caption)
            .italic()
            .foregroundColor(.secondary)
    }

    var projectGroups: [(label: String, projects: [Project])] {
        [
            (label: "Open Projects", projects: Array(openProjects)),
            (label: "Closed Projects", projects: Array(closedProjects))
        ]
    }

    init() {
        _closedProjects = FetchRequest<Project>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Project.title, ascending: true)
            ],
            predicate: NSPredicate(format: "closed = true"))

        _openProjects = FetchRequest<Project>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Project.title, ascending: true)
            ],
            predicate: NSPredicate(format: "closed = false"))
    }

    var body: some View {
        Form {
            // TEMPLATES SECTION
            Section(header: Text("Templates")) {
                Button {
                    makeHundredDollarStartup(dataController)
                } label: {
                    Text("$100 Startup")
                }
            }

            // OPEN/CLOSED PROJECTS SECTION
            ForEach(projectGroups, id: \.label) { projectGroup in
                Section(header: Text(projectGroup.label)) {
                    if projectGroup.projects.isEmpty {
                        noProjectsText
                    } else {
                        ForEach(projectGroup.projects) { project in
                            ProjectToggleClosedRow(project: project)
                        }
                    }
                }
            }
            
            // DELETE DATA SECTION
            DeleteAllDataView()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        SettingsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
