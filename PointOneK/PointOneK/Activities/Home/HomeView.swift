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

            titleAddingRow
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

    var titleAddingRow: some View {
        TitleAddingRow(prompt: "Enter New Project Title") { title in
            withAnimation {
                addProject(titled: title)
                newProjectTitle = ""
            }
        }
    }

    func addProject(titled: String) {
        let project = Project()
        project.closed = false
        project.title = titled
        context.insert(project)
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    HomeView()
}
