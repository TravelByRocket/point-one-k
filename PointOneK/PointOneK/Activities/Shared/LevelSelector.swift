//
//  LevelSelector.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import CoreHaptics
import SwiftUI

struct LevelSelector: View {
    @Binding var value: Int
    let possibleScores: [Int]

    @State private var engine = try? CHHapticEngine()

    var body: some View {
        HStack {
            if value == 0 {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                    .imageScale(.large)
            }
            ForEach(possibleScores, id: \.self) { level in
                Button(
                    action: {
                        withAnimation {
                            if value == level {
                                value = 0
                                valueClearHaptic(engine: engine)
                            } else {
                                value = level
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                        }
                    },
                    label: {
                        Image(systemName: "\(level).square\(value == level ? ".fill" : "")")
                            .font(.title)
                            .padding(.horizontal, -3)
                    }
                )
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

#Preview {
    @Previewable @State var valueA = 1
    @Previewable @State var valueB = 0

    VStack(alignment: .trailing, spacing: 20) {
        LevelSelector(value: $valueA, possibleScores: [1, 2, 3, 4])
        LevelSelector(value: $valueB, possibleScores: [1, 2, 3, 4].reversed())
    }
}
