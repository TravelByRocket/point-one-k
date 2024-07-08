//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import CoreSpotlight
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.managedObjectContext) private var managedObjectContext
    @EnvironmentObject private var dataController: DataController
    @State private var showingSettings = false
    private let newProjectActivity = "co.synodic.PointOneK.newProject"

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
