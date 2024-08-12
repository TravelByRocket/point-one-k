//
//  ColorSelectionSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ColorSelectionSection: View {
    @Binding var selectedColorName: String?
    let colorNames: [String]

    let colorColumns = [
        GridItem(.adaptive(minimum: 42)),
    ]

    var body: some View {
        Section(header: Text("Custom project color")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(colorNames, id: \.self) { colorOptionName in
                    ZStack {
                        Color(colorOptionName)
                            .aspectRatio(1, contentMode: .fit)
                            .cornerRadius(6)

                        if colorOptionName == selectedColorName {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                        }
                    }
                    .onTapGesture {
                        selectedColorName = colorOptionName
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(
                        colorOptionName == selectedColorName
                            ? [.isButton, .isSelected]
                            : .isButton
                    )
                    .accessibilityLabel(LocalizedStringKey(colorOptionName))
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    Form {
        ColorSelectionSection(
            selectedColorName: .constant(Project.example.color),
            colorNames: Project.colors
        )
    }
}
