//
//  LevelSelector.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI
import CoreHaptics

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
            ForEach(1...4, id: \.self) {index in
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
                    })
                    .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}

struct LevelSelector_Previews: PreviewProvider {
    @State static private var valueA = 1
    @State static private var valueB = 0

    static var previews: some View {
        VStack(alignment: .trailing, spacing: 20) {
            LevelSelector(value: $valueA)
            LevelSelector(value: $valueB)
        }
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
