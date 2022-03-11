//
//  EditItemView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct EditItemView: View {
    @ObservedObject var item: Item

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var title: String
    @State var completed: Bool
    @State var priority: Int
    @State var note: String

    init(item: Item) {
        self.item = item

        _title = State(wrappedValue: item.itemTitle)
        _completed = State(wrappedValue: item.completed)
        _priority = State(wrappedValue: Int(item.priority))
        _note = State(wrappedValue: item.itemNote)
    }

    var body: some View {
        Form {
            Section {
                TextField("Title", text: $title.onChange(update))
                    .font(.title)
            }
            ForEach(item.projectQualities.sorted(by: \Quality.qualityTitle)) {quality in
                RowInlineScoringView(quality: quality, item: item)
            }
            if item.projectQualities.isEmpty {
                Text("No project qualities exist")
            }
            Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")
                .background(
                    BackgroundBarView(value: item.scoreTotal, max: item.project?.scorePossible ?? 0)
                )
            Section(header: Text("Item Note")) {
                TextEditor(text: $note.onChange(update))
            }
        }
        .navigationTitle("Edit Item")
        .onDisappear(perform: dataController.save)
    }

    func update() {
        item.project?.objectWillChange.send()

        item.title = title
        item.note = note
        item.completed = completed
        item.priority = Int16(priority)
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            EditItemView(item: Item.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}

private struct RowInlineScoringView: View {
    @State var value: Int
    private let quality: Quality
    private let item: Item
    private let score: Score?

    init(quality: Quality, item: Item) {
        self.quality = quality
        self.item = item
        self.score = quality.score(for: item)
        _value = State(initialValue: score?.scoreValue ?? 0)
    }

    var body: some View {
        DisclosureGroup {
            Text(Quality.example.qualityNote)
                .italic()
                .font(.footnote)
                .foregroundColor(.secondary)
        } label: {
            HStack {
                Text(quality.qualityTitle)
                Spacer()
                LevelSelector(value: $value)
                    .onChange(of: value) { newValue in
                        item.objectWillChange.send()
                        if score != nil {
                            score!.value = Int16(newValue)
                        }
                    }
            }
        }
    }
}
