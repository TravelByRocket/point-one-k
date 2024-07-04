//
//  BatchAddItemsView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 11 Mar 2022.
//

import SwiftUI

struct BatchAddItemsView: View {
    let project: ProjectOld

    @State private var text: String = ""

    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            Text("Add items below, separated by new lines")
            TextEditor(text: $text)
                .overlay {
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke()
                }
            HStack {
                Spacer()
                Button {
                    let lines = text.components(separatedBy: "\n")
                    project.objectWillChange.send()
                    for line in lines {
                        project.addItem(titled: line)
                    }
                    dataController.save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Submit")
                }
                Spacer()
            }
        }
        .padding(5)
    }
}

struct BatchAddItemsView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        BatchAddItemsView(project: ProjectOld.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
