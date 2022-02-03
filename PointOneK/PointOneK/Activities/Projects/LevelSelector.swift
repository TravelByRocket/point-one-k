//
//  LevelSelector.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

struct LevelSelector: View {
    @Binding var value: Int
    var body: some View {
        HStack {
            ForEach(1...4, id: \.self) {index in
                Button(
                    action: {
                        withAnimation {
                            if value == index {
                                value = 0
                            } else {
                                value = index
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
    @State static private var value = 1
    static var previews: some View {
        LevelSelector(value: $value)
    }
}
