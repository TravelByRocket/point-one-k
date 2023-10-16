//
//  ProjectToggleClosedRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectToggleClosedRow: View {
    @Environment(\.modelContext) private var context

//    let isClosed: Bool
//    let title: String
    let project: Project

//    init(project: Project) {
//        self._project = ObservedObject(initialValue: project)
//        self.project = project
//        isClosed = project.closed
//        title = project.projectTitle
//    }

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    project.closed = !project.projectClosed
                }
            } label: {
                Label {
                    Text(project.projectTitle)
                } icon: {
                    Image(systemName: project.projectClosed ? "arrow.up.circle" : "xmark.circle")
                        .foregroundColor(project.projectClosed ? .green : .gray)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct ProjectToggleClosedRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProjectToggleClosedRow(project: Project.example)
        }
    }
}
