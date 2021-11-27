//
//  InfoPill.swift
//  PointOneK
//
//  Created by Bryan Costanza on 12/24/20.
//

import SwiftUI

struct InfoPill: View {
    let letter: Character
    @Binding var level: Int // may not be necessary to have @Binding

    var dots: String {
        var line  = ""
        for _ in 0..<level {
            line += "."
        }
        return line
    }

    var dotsView: some View {
        HStack(spacing: 0.0) {
//        HStack(spacing: 2.2){
            Spacer().frame(minWidth: 0)
            Circle().foregroundColor(level >= 1 ? .primary : .clear)
                .frame(width: 2.5, height: 2.5)
                .aspectRatio(1.0, contentMode: .fit)
                .layoutPriority(2)
            Spacer().frame(minWidth: 0)
            Circle().foregroundColor(level >= 2 ? .primary : .clear)
                .frame(width: 2.5, height: 2.5)
                .aspectRatio(1.0, contentMode: .fit)
                .layoutPriority(2)
            Spacer().frame(minWidth: 0)
            Circle().foregroundColor(level >= 3 ? .primary : .clear)
                .frame(width: 2.5, height: 2.5)
                .aspectRatio(1.0, contentMode: .fit)
                .layoutPriority(2)
            Spacer().frame(minWidth: 0)
            Circle().foregroundColor(level >= 4 ? .primary : .clear)
                .frame(width: 2.5, height: 2.5)
                .aspectRatio(1.0, contentMode: .fit)
                .layoutPriority(2)
            Spacer().frame(minWidth: 0)
        }
//        .frame(width: 2.5)
//        .aspectRatio(1.0, contentMode: .fit)
        .offset(y: -7)
//        .background(Color.green)
    }

    var body: some View {
        ZStack(alignment: .leading) {
//            dotsView
            Text(dots)
                .font(.caption)
                .fontWeight(.bold)
                .offset(y: -10)
            Text(String(level)+String(letter))
                .font(.system(.footnote, design: .monospaced))
                .offset(y: 2)
//                .layoutPriority(2)
//                .overlay(dotsView)
        }
        .padding(4)
        .background(Color.secondary.opacity(0.3))
        .cornerRadius(5.0)
        .padding(.horizontal, -2)
    }
}

struct InfoPill_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InfoPill(letter: "i", level: .constant(1))
            InfoPill(letter: "e", level: .constant(2))
            InfoPill(letter: "v", level: .constant(3))
            InfoPill(letter: "p", level: .constant(4))
            InfoPill(letter: "n", level: .constant(0))
        }.previewLayout(.sizeThatFits)
    }
}
