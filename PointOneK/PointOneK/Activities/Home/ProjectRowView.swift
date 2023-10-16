//
//  ProjectRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectRowView: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.projectTitle)
                .font(.title)
                .underline(true, color: Color(project.projectColor))

            Text("\(qualityCount) Qualities, \(itemCount) Items")

            Text(qualitiesList)
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var qualityCount: Int {
        project.projectQualities.count
    }

    private var itemCount: Int {
        project.projectItems.count
    }

    private var qualitiesList: String {
        project.projectQualities
            .map { $0.qualityTitle }
            .sorted { $0.lowercased() < $1.lowercased() }
            .joined(separator: ", ")
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ProjectRowView(project: Project.example)
            ProjectRowView(project: Project.example)
            ProjectRowView(project: Project.example)
        }
    }
}
