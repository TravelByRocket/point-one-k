//
//  ProjectToggleClosedRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftData
import SwiftUI

struct ProjectToggleClosedRow: View {
    @Bindable var project: Project

    var body: some View {
        Button(action: toggleClosed, label: { label })
            .buttonStyle(.plain)
    }

    private func toggleClosed() {
        withAnimation {
            if project.closed != nil {
                project.closed?.toggle()
            } else {
                project.closed = true
            }
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
