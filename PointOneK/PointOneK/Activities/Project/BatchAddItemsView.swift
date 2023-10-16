//
//  BatchAddItemsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct BatchAddItemsView: View {
    // Private
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.modelContext) private var context
    @State private var text: String = ""

    // Init
    let project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add items below, separated by new lines")

            TextEditor(text: $text)
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke()
                }

            Button {
                let lines = text.components(separatedBy: "\n")
                for line in lines {
                    project.addItem(titled: line)
                }
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Submit")
            }
            .frame(maxWidth: .infinity)
        }
        .padding(5)
    }
}

struct BatchAddItemsView_Previews: PreviewProvider {
    static var previews: some View {
        BatchAddItemsView(project: Project.example)
    }
}
