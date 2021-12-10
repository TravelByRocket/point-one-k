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
            TextField("Title", text: $title.onChange(update))
                .font(.title)
            ForEach(item.projectQualities.sorted(by: \Quality.qualityTitle)) {quality in
                RowInlineScoringView(quality: quality, item: item)
//                ValueRow(title: quality.qualityTitle, value: .constant(Int(quality.score(for: item)?.scoreValue ?? 0)), helpInfo: quality.qualityNote)
            }
            Toggle("Completed", isOn: $completed.onChange(update))
            Picker("Priority Sort Group", selection: $priority.onChange(update)) {
                Text("0 (Unsorted)").tag(0)
                Text("3 (High)").tag(1)
                Text("2 (Normal)").tag(2)
                Text("1 (Low)").tag(3)
            }
            HStack {
                Text("Score: \(item.scoreTotal) of \(item.project?.scorePossible ?? 0)")
                Spacer()
            }
            .background(
                BackgroundBarView(value: item.scoreTotal, max: item.project?.scorePossible ?? 0)
        )
            VStack(alignment: .leading) {
                Text("Notes:")
                TextEditor(text: $note.onChange(update))
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(10.0)
                    .frame(minHeight: 200)
                    .padding(.bottom)
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

fileprivate struct RowInlineScoringView: View {
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
