//
//  BottomBar.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/18/20.
//

import SwiftUI

struct BottomBar: View {
    @EnvironmentObject var category: Category
    @State private var enteringTitle = false
    @State private var newTitle = ""

    var body: some View {
        ZStack {
            Button(
                action: { withAnimation { enteringTitle = true } },
                label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 45)
                })
                .frame(maxWidth: .infinity)
                .overlay(
                    HStack {
                        if !enteringTitle {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Button(
                                    action: { withAnimation { category.sortByTotalScore() } },
                                    label: { Text("Sort") })
                                Spacer()
                                EditButton()
                            }
                            .padding(.trailing)
                        } else {
                            TextField("New Project Title", text: $newTitle)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            VStack(alignment: .trailing) {
                                Button(
                                    action: {
                                        category.ideas.append(Idea(name: newTitle))
                                        newTitle = ""
                                        enteringTitle = false
                                    },
                                    label: { Text("Add") })
                                Spacer()
                                Button(
                                    action: {
                                        newTitle = ""
                                        enteringTitle = false
                                    },
                                    label: {
                                        Text("Cancel")
                                    })
                            }
                            .padding(.trailing)
                            .background(Color.primary.colorInvert().opacity(0.8))
                        }
                    }
                )
        }
        .background(
            Color.primary.colorInvert().opacity(0.8)
                .edgesIgnoringSafeArea(.bottom)
                .padding(-10)
                .blur(radius: 3.0)
        )
    }
}

struct BottomBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomBar()
    }
}
