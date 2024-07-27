//
//  LevelSelector.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import CoreHaptics
import SwiftUI

struct LevelSelector: View {
    @Binding var value: Int?
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
                                value = nil
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
    @Previewable @State var valueA: Int? = 1
    @Previewable @State var valueB: Int? = nil

    VStack(alignment: .trailing, spacing: 20) {
        LevelSelector(
            value: $valueA,
            possibleScores: Quality.example.possibleScores
        )
        LevelSelector(
            value: $valueB,
            possibleScores: Quality.example.possibleScores.reversed()
        )
    }
}
