//
//  ProjectItemsSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectItemsSection: View {
    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var sortOrder = Item.SortOrder.score

    @ObservedObject var project: ProjectOld

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
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(item: item)
                }
                .listRowBackground(
                    BackgroundBarView(
                        value: item.scoreTotal,
                        max: project.scorePossible
                    )
                )
            }
            .onDelete { offsets in
                withAnimation {
                    for offset in offsets {
                        let item = project.projectItems[offset]
                        item.objectWillChange.send()
                        project.objectWillChange.send()
                        dataController.delete(item)
                        dataController.save()
                        dataController.objectWillChange.send()
                    }
                }
            }

            TitleAddingRow(prompt: "Add New Item") { title in
                withAnimation {
                    project.addItem(titled: title)
                    project.objectWillChange.send()
                    dataController.save()
                }
            }
        }
    }

    private var items: [Item] {
        var comparator: (Item, Item) -> Bool {
            switch sortOrder {
            case .title:
                { $0.itemTitle < $1.itemTitle }
            case .score:
                { $0.scoreTotal > $1.scoreTotal }
            }
        }

        return project.projectItems.sorted(by: comparator)
    }
}

#Preview {
    NavigationStack {
        List {
            ProjectItemsSection(
                project: .example
            )
        }
    }
}
