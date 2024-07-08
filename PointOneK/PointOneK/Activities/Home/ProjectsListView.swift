//
//  ProjectsListView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 19 Sep 2021.
//

import SwiftUI

struct ProjectsListView: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    @FetchRequest(
        entity: ProjectOld.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ProjectOld.title, ascending: true)],
        predicate: NSPredicate(format: "closed = false")
    ) var projects: FetchedResults<ProjectOld>

    var projectsList: some View {
        List {
            ForEach(projects) { project in
                NavigationLink {
                    ProjectView(project: project)
                } label: {
                    ProjectRowView(project: project)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var body: some View {
        Group {
            if projects.isEmpty {
                Text("There's nothing here right now")
            } else {
                projectsList
            }
        }
        .navigationTitle("Open Projects")
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    NavigationStack {
        ProjectsListView()
    }
}
