//
//  ProjectTitleEditView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12 Mar 2022.
//

import SwiftUI

struct ProjectTitleEditView: View {
    @State private var title: String
    let project: ProjectOld

    init(project: ProjectOld) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
    }

    var body: some View {
        TextField("Project name", text: $title.onChange(update))
            .font(.title)
    }

    func update() {
        project.objectWillChange.send()
        project.title = title
    }
}

#Preview {
    Form {
        ProjectTitleEditView(project: .example)
    }
}
