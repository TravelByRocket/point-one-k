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

    @State private var engine = try? CHHapticEngine()

    var body: some View {
        HStack {
            if value == 0 {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                    .imageScale(.large)
            }
            ForEach(1 ... 4, id: \.self) { index in
                Button(
                    action: {
                        withAnimation {
                            if value == index {
                                value = 0
                                valueClearHaptic(engine: engine)
                            } else {
                                value = index
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                        }
                    },
                    label: {
                        Image(systemName: "\(index).square\(value == index ? ".fill" : "")")
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
        LevelSelector(value: $valueA)
        LevelSelector(value: $valueB)
    }
}
