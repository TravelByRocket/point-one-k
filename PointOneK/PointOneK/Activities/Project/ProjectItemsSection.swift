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

    @State private var sortOrder = ItemOld.SortOrder.score
    let project: Project

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
            ForEach(project.projectItems) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemRowView(project: project, item: item)
                        .listRowBackground(
                            BackgroundBarView(
                                value: item.scoreTotal,
                                max: project.scorePossible
                            )
                        )
                }
            }
            .onDelete { offsets in
                withAnimation {
                    for offset in offsets {
                        let item = project.projectItems[offset]
                        dataController.delete(item)
                    }
                }
            }

            if project.projectItems.isEmpty {
                Text("No items in this project")
            }

            HStack {
                Button {
                    withAnimation {
                        project.addItem()
                        project.objectWillChange.send()
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

#Preview {
    NavigationStack {
        List {
            ProjectItemsSection(
                project: .example
            )
        }
    }
}
