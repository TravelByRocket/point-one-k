//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import CoreSpotlight
import SwiftUI

struct HomeView: View {
    @State private var showingSettings = false

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    @State var selectedItem: ItemOld?
    @State var newProject: ProjectOld?

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                addProject()
            } label: {
                Label("Add Project", systemImage: "plus")
            }
        }
    }

    var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }

    var body: some View {
        NavigationView {
            if let item = selectedItem {
                NavigationLink(
                    tag: item,
                    selection: $selectedItem,
                    destination: { ItemDetailView(item: item) },
                    label: EmptyView.init
                )
                .id(item)
            }
            if let project = newProject {
                NavigationLink(
                    tag: project,
                    selection: $newProject,
                    destination: { ProjectView(project: project) },
                    label: EmptyView.init
                )
                .id(project)
            }
            ProjectsListView()
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
                .toolbar {
                    settingsToolbarItem
                    addProjectToolbarItem
                }
            SelectSomethingView()
        }
        .navigationViewStyle(.stack)
    }

    func addProject(fromURL: Bool = false) {
        withAnimation {
            let project = ProjectOld(context: managedObjectContext)
            project.closed = false
            dataController.save()
            if fromURL {
                newProject = project
            }
        }
    }

    func createProject(_: NSUserActivity) {
        addProject()
    }

    func selectItem(with identifier: String) {
        selectedItem = dataController.item(with: identifier)
    }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectItem(with: uniqueIdentifier)
        }
    }

    func openURL(_: URL) {
        addProject(fromURL: true)
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    HomeView()
}
