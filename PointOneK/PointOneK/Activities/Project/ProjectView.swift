//
//  EditProjectView.swift
//  PointOneK
//
//  Created by Bryan Costanza on 4 Oct 2021.
//

import SwiftUI
import CloudKit

struct ProjectView: View {
    let project: Project

    @EnvironmentObject private var dataController: DataController
    @Environment(\.managedObjectContext) private var managedObjectContext

    var body: some View {
        Form {
            ProjectTitleEditView(project: project)
            Section(header: Text("Description")) {
                ProjectDetailEditView(project: project)
            }
            ProjectItemsSection(project: project, dataController: dataController)
            ProjectQualitiesSection(project: project)
            ProjectColorSelectionSection(project: project)
            ProjectArchiveDeleteSection(project: project)
        }
        .navigationTitle("Edit Project")
        .toolbar {
            Button {
                let records = project.prepareCloudRecords()
                let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)

                operation.savePolicy = .allKeys

//                operation.modifyRecordsCompletionBlock = { _, _, error in
//                    if let error = error {
//                        print("Error: \(error.localizedDescription)")
//                    }
//                }
                operation.modifyRecordsResultBlock = { result in
                    switch result {
                    case .success:
                        print("Data uploaded to iCloud")
                    case .failure:
                        print("Error: \(result)")
                    }
                }

                let container = CKContainer.default()
//                print(container.containerIdentifier as? String "oops")
                container.publicCloudDatabase.add(operation)
//                CKContainer(identifier: "iCloud.co.synodic.PointOneK").publicCloudDatabase.add(operation)
            } label: {
                Label {
                    Text("Upload to iCloud")
                } icon: {
                    Image(systemName: "icloud.and.arrow.up")
                }

            }

        }
        .onDisappear(perform: dataController.save)
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        NavigationView {
            ProjectView(project: Project.example)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
