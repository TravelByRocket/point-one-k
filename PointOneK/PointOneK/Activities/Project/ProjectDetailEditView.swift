//
//  ProjectDetailEditView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectDetailEditView: View {
    @State private var detail: String

    @Bindable var project: Project

    init(project: Project) {
        self.project = project
        _detail = State(wrappedValue: project.projectDetail)
    }

    var body: some View {
        TextEditor(text: $detail.onChange(update))
            .font(.caption)
    }

    func update() {
        project.detail = detail
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    Form {
        ProjectDetailEditView(project: .example)
    }
}
