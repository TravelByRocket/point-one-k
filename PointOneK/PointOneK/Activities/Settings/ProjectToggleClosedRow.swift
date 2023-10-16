//
//  ProjectToggleClosedRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectToggleClosedRow: View {
//    let isClosed: Bool
//    let title: String
    @ObservedObject private var project: ProjectOld

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext

    init(project: ProjectOld) {
        self._project = ObservedObject(initialValue: project)
//        self.project = project
//        isClosed = project.closed
//        title = project.projectTitle
    }

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    project.objectWillChange.send()
                    project.closed.toggle()
                    dataController.save()
                }
            } label: {
                Label {
                    Text(project.projectTitle)
                } icon: {
                    Image(systemName: project.closed ? "arrow.up.circle" : "xmark.circle")
                        .foregroundColor(project.closed ? .green : .gray)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

struct ProjectToggleClosedRow_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        List {
            ProjectToggleClosedRow(project: ProjectOld.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
