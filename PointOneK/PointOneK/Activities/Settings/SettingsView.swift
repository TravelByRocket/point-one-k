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
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

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

    private var noProjectsText: some View {
        Text("No projects here")
            .italic()
            .foregroundColor(.secondary)
    }

    private var projectGroups: [(label: String, projects: [Project])] {
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
                    let project = HundredDollarStartup.project
                    project.qualities = HundredDollarStartup.qualities
                    context.insert(project)
                    dismiss()
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
                        #warning("Revive widget project selection")
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
