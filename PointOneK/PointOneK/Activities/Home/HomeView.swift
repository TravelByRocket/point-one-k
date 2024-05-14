//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import SwiftData

struct HomeView: View {
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
