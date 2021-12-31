//
//  NewTaskView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct NewTaskView: View {

    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var appState: AppState

    var project: Project

    @State private var name = ""

    private let width: CGFloat = 500

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "text.badge.plus")
                    .foregroundColor(.teal)
                    .font(.title)
                Text("New task")
                    .bold()
                Spacer()
            }

            VStack(spacing: 10) {
                HStack(alignment: .center, spacing: 10) {
                    Text("Description:")
                        .frame(width: 94, alignment: .trailing)

                    TextField("Description", text: $name)
                        .textFieldStyle(.squareBorder)
                        .frame(width: width, alignment: .leading)
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Project:")
                        .frame(width: 94, alignment: .trailing)
                    Text(project.name)
                        .foregroundColor(.secondary)
                        .frame(width: width, alignment: .leading)
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Folder:")
                        .frame(width: 94, alignment: .trailing)
                    Text(project.folder.name)
                        .foregroundColor(.secondary)
                        .frame(width: width, alignment: .leading)
                }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    let task = ProjectTask(name: name)
                    Task {
                        await appState.save(task: task, in: project)
                    }
                    dismiss()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .fixedSize()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        let folder = Folder(name: "Test")
        let project = Project(name: "Test Project", folder: folder)
        NewTaskView(project: project)
    }
}
