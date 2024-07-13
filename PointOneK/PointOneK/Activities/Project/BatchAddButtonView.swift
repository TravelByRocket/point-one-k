//
//  BatchAddButtonView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct BatchAddButtonView: View {
    let project: ProjectV2

    @State private var holdCompletionPct: CGFloat = 0.0
    @State private var showBatchEntry = false

    private let batchHoldTimerLength = 1.5

    var body: some View {
        Text("Hold to\nBatch Add")
            .foregroundColor(.secondary)
            .padding(5)
            .overlay {
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke()
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 5.0)
                    .trim(from: 1.0 - holdCompletionPct, to: 1.0)
                    .stroke()
            }
            .font(.caption)
            .multilineTextAlignment(.center)
            .tint(.secondary)
            .onLongPressGesture(minimumDuration: batchHoldTimerLength, maximumDistance: 50) {
                holdCompletionPct = 0.0
                showBatchEntry.toggle()
            } onPressingChanged: { isNowPressing in
                if isNowPressing {
                    withAnimation(.linear(duration: batchHoldTimerLength)) {
                        holdCompletionPct = 1.0
                    }
                } else {
                    holdCompletionPct = 0.0
                }
            }
            .sheet(isPresented: $showBatchEntry) {
                BatchAddItemsView(project: project)
            }
    }
}

#Preview {
    BatchAddButtonView(project: .example)
}
