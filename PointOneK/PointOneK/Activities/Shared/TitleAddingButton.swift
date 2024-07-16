//
//  TitleAddingButton.swift
//  PointOneK
//
//  Created by Bryan Costanza on 7/15/24.
//

import SwiftUI

struct TitleAddingButton: View {
    @State private var text: String = ""

    let prompt: String
    let onAdd: (String) -> Void

    var body: some View {
        HStack {
            TextField(prompt, text: $text)
                .textFieldStyle(.roundedBorder)

            Button {
                onAdd(text)
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
        TitleAddingButton(
            prompt: "New Item Name",
            onAdd: { _ in }
        )
    }
}
