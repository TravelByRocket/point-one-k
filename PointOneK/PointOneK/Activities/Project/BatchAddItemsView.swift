//
//  BatchAddItemsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct BatchAddItemsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text: String = ""

    let project: ProjectV2

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

                    for line in lines {
                        project.addItem(titled: line)
                    }

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
