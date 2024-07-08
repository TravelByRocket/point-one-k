//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

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
        NavigationStack {
            ProjectsListView()
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
                .toolbar {
                    settingsToolbarItem
                    addProjectToolbarItem
                }
        }
    }

    func addProject() {
        withAnimation {
            let project = ProjectOld(context: managedObjectContext)
            project.closed = false
            dataController.save()
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    HomeView()
}
