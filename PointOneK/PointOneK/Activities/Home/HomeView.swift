//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var context

    @State private var showingSettings = false
    @State private var newProjectTitle = ""

    var body: some View {
        NavigationStack {
            ProjectsListView()
                .toolbar { settingsToolbarItem }

            addProjectRow
                .padding()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    var settingsToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button {
                showingSettings.toggle()
            } label: {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }

    // MARK: Add Project

    var addProjectRow: some View {
        HStack {
            titleTextField
            addProjectButton
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
        Button {
            withAnimation {
                addProject()
            }
        } label: {
            Label("Add Project", systemImage: "plus")
        }
        .labelStyle(.iconOnly)
        .disabled(newProjectTitle.isEmpty)
    }

    func addProject() {
        let project = ProjectV2()
        project.closed = false
        project.title = newProjectTitle
        newProjectTitle = ""
        context.insert(project)
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    HomeView()
}
