//
//  ProjectColorSelect.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectColorButtonView: View {
    let item: String
    @Binding var color: String

    var body: some View {
        ZStack {
            Color(item)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(6)

            if item == color {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
        .onTapGesture {
            color = item
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(
            item == color
            ? [.isButton, .isSelected]
            : .isButton
        )
        .accessibilityLabel(LocalizedStringKey(item))
    }
}

struct ProjectColorButtonView_Previews: PreviewProvider {
    static var item1 = "Green"
    static var item2 = "Orange"
    @State static var color = "Orange"

    static var previews: some View {
        VStack {
            ProjectColorButtonView(item: item1, color: $color)
            ProjectColorButtonView(item: item2, color: $color)
        }
    }
}
