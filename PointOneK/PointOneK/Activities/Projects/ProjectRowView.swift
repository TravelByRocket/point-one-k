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

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(qualityCount) Qualities, \(itemCount) Items")
                Text(project.projectQualities.map { $0.qualityTitle }.joined(separator: ", "))
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)

            }
            Spacer()
        }
//        .frame(maxWidth: .infinity)
    }
}

struct ProjectRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectRowView(project: Project.example)
    }
}
