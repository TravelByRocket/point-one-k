//
//  ProjectRowView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct ProjectRowView: View {
    @ObservedObject var project: Project

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
        let qualitiesCount = project.projectQualities.count
        let itemsCount = project.projectItems.count
        return "\(qualitiesCount) Qualities, \(itemsCount) Items"
    }

    var qualitiesList: String {
        project.projectQualities
            .map(\.qualityTitle)
            .sorted { $0.localizedCompare($1) == .orderedAscending }
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
