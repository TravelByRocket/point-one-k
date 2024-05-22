//
//  BatchAddItemsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI
import SwiftData

struct BatchAddItemsView: View {
    let project: Project

    @State private var text: String = ""

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add items below, separated by new lines")
            TextEditor(text: $text)
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke()
                }
            HStack {
                Spacer()

                Button {
                    let lines = text.components(separatedBy: "\n")

                    project.objectWillChange.send()

                    for line in lines {
                        project.addItem(titled: line, in: context)
                    }

                    dataController.save()

                    dismiss()
                } label: {
                    Text("Submit")
                }

                Spacer()
            }
        }
        .padding(5)
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    BatchAddItemsView(project: .example)
}
