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
    private var closedProjects: [ProjectV2]

    @Query(
        filter: #Predicate<ProjectV2> { $0.closed == false },
        sort: \ProjectV2.title,
        order: .forward
    )
    private var openProjects: [ProjectV2]

    @State private var widgetProject: URL? = UserDefaults(
        suiteName: "group.co.synodic.PointOneK")?.url(forKey: "widgetProject")

    var noProjectsText: some View {
        Text("No projects here")
            .italic()
            .foregroundColor(.secondary)
    }

    var projectGroups: [(label: String, projects: [ProjectV2])] {
        [
            (label: "Open Projects", projects: Array(openProjects)),
            (label: "Closed Projects", projects: Array(closedProjects)),
        ]
    }

    var body: some View {
        List {
            // TEMPLATES SECTION
            Section(header: Text("Templates")) {
                Button {
                    #warning("unable to make $100 Startup template")
//                    makeHundredDollarStartup(dataController)
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
                    ForEach(openProjects.sorted(by: \ProjectV2.projectTitle)) { project in
                        Text(project.projectTitle)
                        #warning("URI tag not available for widget selection")
//                            .tag((project.objectID.uriRepresentation()) as URL?)
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
