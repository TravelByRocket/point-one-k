//
//  ContentView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11/14/20.
//

import SwiftUI

struct ProjectsViewOld: View {
    static let openTag: String? = "Open"
    static let closedTag: String = "Closed"

    @StateObject var category = Category()
    @AppStorage("settings") var settingsData: Data = Data()

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(category.ideas) {idea in
                        NavigationLink(destination: IdeaPage(idea: idea)) {
                            IdeaRow(idea: idea)
                        }
                    }
                    .onDelete(perform: delete)
                    .onMove { (indexSet, index) in
                        category.ideas.move(fromOffsets: indexSet, toOffset: index)
                    }
                }
                .listStyle(PlainListStyle())
                .onReceive(category.$ideas, perform: { _ in
                    category.saveToUserDefaults()
                })
                BottomBar()
            }
            .navigationTitle("$0.1K Startup Ideas")
        }
        .environmentObject(category)
        .onAppear {
            guard let settings = try? JSONDecoder().decode(Category.self, from: settingsData) else {return}
            self.category.ideas = settings.ideas
        }
    }

    func delete(at offsets: IndexSet) {
        category.ideas.remove(atOffsets: offsets)
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsViewOld()
    }
}
