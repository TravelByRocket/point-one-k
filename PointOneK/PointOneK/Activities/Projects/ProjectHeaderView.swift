//
//  ProjectHeaderView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 3 Oct 2021.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project

    var body: some View {
        HStack {
            Text(project.projectTitle)
                .font(.title2)
            Spacer()
            NavigationLink(destination: EditProjectView(project: project)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header: ProjectHeaderView(project: Project.example)) {
                    Text("Anything")
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}
