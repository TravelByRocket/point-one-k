//
//  BackgroundBarView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 2 Dec 2021.
//

import SwiftUI

struct BackgroundBarView: View {
    let value: Int
    let max: Int
    var expandPadding = true

    var hueAngle: Angle {
        // avoid divide by zero error
        if max != 0 {
            Angle(degrees: Double(360 * value / max))
        } else {
            Angle(degrees: 0.0)
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.secondarySystemGroupedBackground)
                RoundedRectangle(cornerRadius: 3)
                    .padding(4)
                    .frame(
                        width: getBarWidth(geo: geo),
                        alignment: .leading
                    )
                    .foregroundColor(.red)
                    .opacity(0.5)
                    .hueRotation(hueAngle)
                    .animation(.easeInOut(duration: 0.1), value: value)
            }
        }
    }

    func getBarWidth(geo: GeometryProxy) -> CGFloat {
        // avoid divide by zero error
        if max != 0 {
            geo.size.width * CGFloat(value) / CGFloat(self.max)
        } else {
            0.0
        }
    }
}

#Preview {
    VStack {
        List {
            Section("Typical Use") {
                ForEach(0 ..< 6) { index in
                    HStack {
                        Text("Item")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(BackgroundBarView(value: index, max: 5))
                }
            }

            Section("Corner Cases") {
                BackgroundBarView(value: 0, max: 0)
                BackgroundBarView(value: 1, max: 100)
                BackgroundBarView(value: 1, max: 1)
            }
        }
    }
}
