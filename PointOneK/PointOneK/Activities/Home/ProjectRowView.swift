//
//  ProjectRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectRowView: View {
    @ObservedObject var project: Project

    var qualityCount: Int {
        project.projectQualities.count
    }

    var itemCount: Int {
        project.projectItems.count
    }

    var qualitiesList: String {
        project.projectQualities
            .map { $0.qualityTitle }
            .sorted { $0.lowercased() < $1.lowercased() }
            .joined(separator: ", ")
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                    .font(.title)
                    .underline(true, color: Color(project.projectColor))
                    .lineLimit(1)
                Text("\(qualityCount) Qualities, \(itemCount) Items")
                Text(qualitiesList)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
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
