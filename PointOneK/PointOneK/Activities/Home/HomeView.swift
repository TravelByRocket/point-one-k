//
//  HomeView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import CoreSpotlight

struct HomeView: View {
    @State private var showingSettings = false

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    @State var selectedItem: Item?

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
                    destination: {ItemDetailView(item: item)},
                    label: EmptyView.init
                )
                    .id(item)
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
    }

    func addProject() {
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            dataController.save()
        }
    }

    func selectItem(with identifier: String) {
        selectedItem = dataController.item(with: identifier)
    }

    func loadSpotlightItem(_ userActivity: NSUserActivity) {
        if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            selectItem(with: uniqueIdentifier)
        }
    }

}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
