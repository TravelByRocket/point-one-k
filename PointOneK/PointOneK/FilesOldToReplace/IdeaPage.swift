//
//  IdeaPage.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

// swiftlint:disable identifier_name

import SwiftUI

struct IdeaPage: View {
    @EnvironmentObject private var c: Category
    @ObservedObject var idea: Idea

    var body: some View {
        Form {
            TextField("Idea Name", text: $idea.name)
                .font(.title)
            ValueRow(title: "Impact", value: $idea.impact, helpInfo: Category.impactDesc)
            ValueRow(title: "Effort", value: $idea.effort, helpInfo: Category.effortDesc)
            ValueRow(title: "Vision", value: $idea.vision, helpInfo: Category.visionDesc)
            ValueRow(title: "Profitability", value: $idea.profitability, helpInfo: Category.profitDesc)
            HStack {
                Text("Score: \(idea.totalScore) of 16")
                Spacer()
            }
            .background(
                BackgroundBarView(value: idea.impact+idea.effort+idea.vision+idea.profitability, max: 16)
        )
            VStack(alignment: .leading) {
                Text("Notes:")
                TextEditor(text: $idea.notes)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(10.0)
                    .frame(height: 200)
                    .padding(.bottom)
            }
        }
        .onDisappear {
            c.saveToUserDefaults()
        }
        .onReceive(idea.$name, perform: { _ in c.saveToUserDefaults() })
        .onReceive(idea.$impact, perform: { _ in c.saveToUserDefaults() })
        .onReceive(idea.$effort, perform: { _ in c.saveToUserDefaults() })
        .onReceive(idea.$vision, perform: { _ in c.saveToUserDefaults() })
        .onReceive(idea.$profitability, perform: { _ in c.saveToUserDefaults() })
//        .onReceive(idea.$notes,         perform: { _ in c.saveToUserDefaults() })
    }
}

struct IdeaPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            IdeaPage(idea: Idea())
        }
        .environmentObject(Category())
    }
}
