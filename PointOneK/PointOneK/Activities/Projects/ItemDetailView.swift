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
                RowInlineScoringView(quality: quality, item: item)
            }
            if item.projectQualities.isEmpty {
                Text("No project qualities exist")
            }
            HStack {
                Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")
                Spacer()
            }
            .background {
                BackgroundBarView(value: item.scoreTotal, max: item.project?.scorePossible ?? 0)
            }
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
            Text(quality.qualityNote)
                .italic()
                .font(.footnote)
                .foregroundColor(.secondary)
        } label: {
            HStack {
                Text(quality.qualityTitle)
                Spacer()
                LevelSelector(value: $value)
                    .onChange(of: value) { newValue in
                        score?.item?.objectWillChange.send()
                        score?.value = Int16(newValue)
                    }
            }
        }
    }
}
