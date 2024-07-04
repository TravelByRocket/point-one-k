//
//  ProjectColorSelectionSection.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectColorSelectionSection: View {
    @ObservedObject var project: ProjectOld

    @State private var color: String

    init(project: ProjectOld) {
        self.project = project
        _color = State(initialValue: project.projectColor)
    }

    let colorColumns = [
        GridItem(.adaptive(minimum: 42)),
    ]

    var body: some View {
        Section(header: Text("Custom project color")) {
            LazyVGrid(columns: colorColumns) {
                ForEach(ProjectOld.colors, id: \.self) { item in
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
                        update()
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
        }
        .padding(.vertical)
    }

    func update() {
        project.objectWillChange.send()
        project.color = color
    }
}

struct ProjectColorSelectionSection_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            ProjectColorSelectionSection(project: ProjectOld.example)
        }
    }
}
