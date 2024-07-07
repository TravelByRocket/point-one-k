//
//  ProjectDetailEditView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectDetailEditView: View {
    @State private var detail: String
    let project: ProjectOld

    init(project: ProjectOld) {
        self.project = project
        _detail = State(wrappedValue: project.projectDetail)
    }

    var body: some View {
        TextEditor(text: $detail.onChange(update))
            .font(.caption)
    }

    func update() {
        project.objectWillChange.send()
        project.detail = detail
    }
}

#Preview {
    Form {
        ProjectDetailEditView(project: ProjectOld.example)
    }
}
