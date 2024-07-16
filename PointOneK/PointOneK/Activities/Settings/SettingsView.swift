//
//  SettingsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 10 Dec 2021.
//

import SwiftData
import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Query(
        filter: #Predicate<ProjectV2> { $0.closed == true },
        sort: \ProjectV2.title,
        order: .forward
    )
    private var closedProjectsV2: [ProjectV2]

    @Query(
        filter: #Predicate<ProjectV2> { $0.closed == false },
        sort: \ProjectV2.title,
        order: .forward
    )
    private var openProjectsV2: [ProjectV2]

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest var closedProjects: FetchedResults<ProjectOld>
    @FetchRequest var openProjects: FetchedResults<ProjectOld>

    @State private var widgetProject: URL? = UserDefaults(
        suiteName: "group.co.synodic.PointOneK")?.url(forKey: "widgetProject")

    var noProjectsText: some View {
        Text("No projects here")
            .italic()
            .foregroundColor(.secondary)
    }

    var projectGroups: [(label: String, projects: [Project])] {
        [
            (label: "Open Projects", projects: Array(openProjects)),
            (label: "Closed Projects", projects: Array(closedProjects)),
        ]
    }

    init() {
        _closedProjects = FetchRequest<ProjectOld>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \ProjectOld.title, ascending: true),
            ],
            predicate: NSPredicate(format: "closed = true")
        )

        _openProjects = FetchRequest<ProjectOld>(
            sortDescriptors: [
                NSSortDescriptor(keyPath: \ProjectOld.title, ascending: true),
            ],
            predicate: NSPredicate(format: "closed = false")
        )
    }

    var body: some View {
        List {
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

            Section(
                header: Text("Widget Project"),
                footer: Text("If you close your widget project it will remain visible in the widget.")
            ) {
                Picker("Pick Project", selection: $widgetProject) {
                    ForEach(openProjects.sorted(by: \Project.projectTitle)) { project in
                        Text(project.projectTitle)
                            .tag((project.objectID.uriRepresentation()) as URL?)
                    }
                    Text("Use Placeholder Project")
                        .italic()
                        .tag(nil as URL?)
                }
                .pickerStyle(.inline)
                .labelsHidden()
                .onChange(of: widgetProject) {
                    UserDefaults(suiteName: "group.co.synodic.PointOneK")?.set(widgetProject, forKey: "widgetProject")
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }

            // DELETE DATA SECTION
            DeleteAllDataView()
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    SettingsView()
}
