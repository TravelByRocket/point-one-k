//
//  ProjectToggleClosedRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectToggleClosedRow: View {
//    @Bindable var project: Project

    @ObservedObject var project: ProjectOld

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    var body: some View {
        Button(action: toggleClosed, label: { label })
            .buttonStyle(.plain)
    }

    private func toggleClosed() {
        withAnimation {
            project.closed.toggle()
//            if project.closed != nil {
//                project.closed?.toggle()
//            } else {
//                project.closed = true
//            }
        }
    }

    private var label: some View {
        Label {
            Text(project.projectTitle)
        } icon: {
            Image(systemName: systemName)
                .foregroundColor(project.closed == true ? .green : .gray)
        }
    }

    private var systemName: String {
        project.closed == true ? "arrow.up.circle" : "xmark.circle"
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ProjectToggleClosedRow(project: .example)
    }
}
