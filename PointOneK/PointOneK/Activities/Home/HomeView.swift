//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import CoreSpotlight

struct HomeView: View {
    // Private
    @Environment(\.modelContext) private var context
    @State private var iShowingSettings = false
    private let newProjectActivity = "co.synodic.PointOneK.newProject"

    // Init
    @State var selectedItem: Item?
    @State var newProject: Project?

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
                iShowingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }

    var body: some View {
        NavigationStack {
            NavigationLink(value: selectedItem) {
                EmptyView()
            }
            
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
                .sheet(isPresented: $iShowingSettings) {
                    SettingsView()
                }
                .toolbar {
                    settingsToolbarItem
                    addProjectToolbarItem
                }

            SelectSomethingView()
        }
        // Documented issue through at least 15.1.1. Currently using 15.2.
        // Views are improperly popping when updating `@ObservedObject`s
        // Details at https://developer.apple.com/forums/thread/665369
        .navigationViewStyle(.stack)
        .onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
        .onContinueUserActivity(newProjectActivity, perform: createProject)
        .userActivity(newProjectActivity) { activity in
            activity.title = "New Project"
            activity.isEligibleForPrediction = true
        }
        .onOpenURL(perform: openURL)
    }

    func addProject(fromURL: Bool = false) {
        withAnimation {
            let project = Project()
            project.closed = false
            context.insert(project)
            if fromURL {
                newProject = project
            }
        }
    }

    func createProject(_ userActivity: NSUserActivity) {
        addProject()
    }

    func selectItem(with identifier: String) {
//        selectedItem = dataController.item(with: identifier)
    }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectItem(with: uniqueIdentifier)
        }
    }

    func openURL(_ url: URL) {
        addProject(fromURL: true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
