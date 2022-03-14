//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectItemsSection: View {
    @ObservedObject var project: Project

    @State private var sortOrder = Item.SortOrder.score
    @SceneStorage("selectedItemID") var selectedItemObjectID: String?

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    var items: [Item] {
        project.projectItems(using: sortOrder)
    }

    var itemSortingHeader: some View {
        HStack {
            Text("Items by \(sortOrder == .title ? "Title, Score" : "Score, Title")")
            Spacer()
            Button {
                withAnimation {
                    if sortOrder == .title {
                        sortOrder = .score
                    } else { // if sortOrder == .score
                        sortOrder = .title
                    }
                }
            } label: {
                Label {
                    Text("Switch sort priority")
                } icon: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .labelStyle(.iconOnly)
            }
        }
    }

    var body: some View {
        Section(header: itemSortingHeader) {
            ForEach(items) { item in
                NavigationLink(
                    tag: String(item.id.debugDescription),
                    selection: $selectedItemObjectID) {
                        ItemDetailView(item: item)
                    } label: {
                        ItemRowView(project: project, item: item)
                    }
            }
            .onDelete(perform: {offsets in
                for offset in offsets {
                    withAnimation {
                        let item = items[offset]
                        dataController.delete(item)
                    }
                }
                project.objectWillChange.send()
                dataController.save()
            })
            if items.isEmpty {
                Text("No items in this project")
            }
            HStack {
                Button {
                    withAnimation {
                        project.addItem()
                        dataController.save()
                    }
                } label: {
                    Label("Add New Item", systemImage: "plus")
                        .accessibilityLabel("Add new item")
                }
                Spacer()
                BatchAddButtonView(project: project)
            }
        }
    }
}

struct ProjectItemsSection_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            List {
                ProjectItemsSection(project: Project.example)
            }
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}