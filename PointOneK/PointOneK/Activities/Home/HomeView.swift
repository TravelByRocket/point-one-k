//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var context

    // Private
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

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
            ProjectsListView()
                .toolbar {
                    settingsToolbarItem
                    addProjectToolbarItem
                }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    // MARK: Add Project

    var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            HStack {
                titleTextField
                addProjectButton
            }
        }
    }

    var titleTextField: some View {
        TextField(
            "Enter New Project Title",
            text: $newProjectTitle
        )
        .textFieldStyle(.roundedBorder)
    }

    var addProjectButton: some View {
        Button(action: addProject) {
            Label("Add Project", systemImage: "plus")
        }
        .navigationViewStyle(.stack)
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
