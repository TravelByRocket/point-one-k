//
//  ProjectRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectRowView: View {
    @Bindable var project: ProjectV2

    var body: some View {
        VStack(alignment: .leading) {
            Text(project.projectTitle)
                .font(.title)
                .underline(true, color: Color(project.projectColor))
                .lineLimit(1)

            Text(summary)

            Text(qualitiesList)
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var summary: String {
        "\(project.projectQualities.count) Qualities, \(project.projectItems.count) Items"
    }

    var qualitiesList: String {
        project.projectQualities
            .map(\.qualityTitle)
            .sorted { $0.lowercased() < $1.lowercased() }
            .joined(separator: ", ")
    }
}

#Preview {
    List {
        ProjectRowView(project: .example)
        ProjectRowView(project: .example)
        ProjectRowView(project: .example)
    }
}
