//
//  TitleAddingRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/15/24.
//

import SwiftUI

struct TitleAddingRow: View {
    @State private var text: String = ""

    let prompt: String
    let addingAction: (String) -> Void

    var body: some View {
        HStack {
            TextField(prompt, text: $text)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    addingAction(text)
                    text = ""
                }

            Button {
                addingAction(text)
                text = ""
            } label: {
                addLabelView
            }
            .disabled(text.isEmpty)
        }
    }

    private var addLabelView: some View {
        Label {
            Text(prompt)
        } icon: {
            Image(systemName: "plus")
        }
        .labelStyle(.iconOnly)
    }
}

#Preview {
    Form {
        TitleAddingRow(
            prompt: "New Item Name",
            addingAction: { _ in }
        )
    }
}
