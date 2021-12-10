//
//  BackgroundBarBiew.swift
//  PointOneK
//
//  Created by Bryan Costanza on 2 Dec 2021.
//

import SwiftUI

struct BackgroundBarView: View {
    let value: Int
    let max: Int

    var hueAngle: Angle {
        // avoid divide by zero error
        if max != 0 {
            return Angle(degrees: Double(360 * (value) / max))
        } else {
            return Angle(degrees: 0.0)
        }
    }

    var body: some View {
        GeometryReader {geo in
            Rectangle()
                .cornerRadius(3.0)
                .padding(-5)
                .frame(
                    width: getBarWidth(geo: geo),
                    alignment: .leading)
                .foregroundColor(.red)
                .opacity(0.5)
                .hueRotation(hueAngle)
                .animation(.easeInOut(duration: 0.1))
        }
    }

    func getBarWidth(geo: GeometryProxy) -> CGFloat {
        // avoid divide by zero error
        if max != 0 {
            return geo.size.width * CGFloat(self.value) / CGFloat(self.max)
        } else {
            return 0.0
        }
    }
}

struct BackgroundBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            List(0..<6) {i in
                HStack {
                    Text("Item")
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(BackgroundBarView(value: i, max: 5))
            }
            List {
                BackgroundBarView(value: 0, max: 0)
                BackgroundBarView(value: 1, max: 100)
                BackgroundBarView(value: 1, max: 1)
            }
        }
    }
}
