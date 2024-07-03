//
//  ModelPreview.swift
//  PointOneK
//
//  Created by Bryan Costanza on 5/30/24.
//

import SwiftData
import SwiftUI

public struct ModelPreview<Model: PersistentModel, Content: View>: View {
    var container: ModelContainer
    var content: (Model) -> Content

    public init(
        container: ModelContainer,
        @ViewBuilder content: @escaping (Model) -> Content
    ) {
        self.container = container
        self.content = content
    }

    public var body: some View {
        PreviewContentView(content: content)
            .modelContainer(container)
    }

    struct PreviewContentView: View {
        var content: (Model) -> Content

        @Query private var models: [Model]
        @State private var waitedToShowIssue = false

        var body: some View {
            if let model = models.first {
                content(model)
            } else {
                ContentUnavailableView {
                    Label {
                        Text(verbatim: "Could not load model for previews")
                    } icon: {
                        Image(systemName: "xmark")
                    }
                }
                .opacity(waitedToShowIssue ? 1 : 0)
                .task {
                    Task {
                        try await Task.sleep(for: .seconds(1))
                        waitedToShowIssue = true
                    }
                }
            }
        }
    }
}
