//
//  EditItemView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var item: Item

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var title: String
    @State var note: String

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _note = State(wrappedValue: item.itemNote)
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title.onChange(update))
                    .font(.title)
            }
            ForEach(item.projectQualities.sorted(by: \Quality.qualityTitle)) {quality in
                ScoringRowDisclosing(
                    label: quality.qualityTitle,
                    score: quality.score(for: item) ?? Score.example)
            }
            if item.projectQualities.isEmpty {
                Text("No project qualities exist")
            }
            HStack {
                Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")
                Spacer()
            }
            .listRowBackground(
                BackgroundBarView(value: item.scoreTotal, max: item.project?.scorePossible ?? 0)
            )
            Section(header: Text("Item Note")) {
                TextEditor(text: $note.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: save)
    }

    func update() {
        item.project?.objectWillChange.send()
        item.title = title
        item.note = note
    }

    func save() {
        dataController.update(item)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ItemDetailView(item: Item.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
