//
//  EditItemView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 20 Sep 2021.
//

import SwiftUI

struct EditItemView: View {
    let item: Item

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
            Toggle("Completed", isOn: $completed.onChange(update))
            Picker("Priority Sort Group", selection: $priority.onChange(update)) {
                Text("0 (Unsorted)").tag(0)
                Text("3 (High)").tag(1)
                Text("2 (Normal)").tag(2)
                Text("1 (Low)").tag(3)
            }
            Section(header: Text("Note")) {
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
    static var previews: some View {
        NavigationView {
            EditItemView(item: Item.example)
        }
    }
}
