//
//  ValueRow.swift
//  PointOneK
//
//  Created by Bryan Costanza on 29 Nov 2021.
//

import SwiftUI

struct ValueRow: View {
    let title: String
    @Binding var value: Int
    let helpInfo: String

    @State private var showHelp = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    showHelp.toggle()
                }, label: {
                    Image(systemName: "chevron.\(showHelp ? "up" : "down").circle")
                        .foregroundColor(.secondary)
                })
                .buttonStyle(BorderlessButtonStyle())
                Text(title)
                Spacer()
                LevelSelector(value: $value)
            }
            if showHelp {
                Text(helpInfo)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct ValueRow_Previews: PreviewProvider {
    static var previews: some View {
        ValueRow(title: "Title", value: .constant(2), helpInfo: "help here")
    }
}
