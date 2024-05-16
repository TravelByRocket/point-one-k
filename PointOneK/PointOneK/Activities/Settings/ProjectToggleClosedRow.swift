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
    var project: Project

    @EnvironmentObject var dataController: DataController

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    #warning("toggle of property not allowed")
//                    project.closed.toggle()
                }
            } label: {
                Label {
                    Text(project.projectTitle)
                } icon: {
                    Image(systemName: project.closed == true ? "arrow.up.circle" : "xmark.circle")
                        .foregroundColor(project.closed == true ? .green : .gray)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview(traits: .modifier(.persistenceLayer)) {
    List {
        ProjectToggleClosedRow(project: .example)
    }
}
