//
//  NewProjectView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import OSLog

fileprivate let logger = Logger("NewProjectView")

struct NewProjectView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    @State private var name = ""
    @State private var folder = Folder(name: "None") // Updated in .onAppear

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "folder.badge.plus")
                    .foregroundColor(.mint)
                    .font(.title)
                Text("Add a new project")
                    .bold()
                Spacer()
            }

            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 10) {
                    Text("Name:")
                        .frame(width: 64, alignment: .trailing)
                    TextField("Project name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Folder:")
                        .frame(width: 64, alignment: .trailing)
                    Picker("Folder", selection: $folder) {
                        ForEach(appState.folders, id: \.self) { folder in
                            Text(folder.name).tag(folder)
                        }
                    }
                    .labelsHidden()
                    .fixedSize()
                    .frame(width: 300, alignment: .leading)
                }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    saveProject()
                    dismiss()
                }
                // On MacOS 12 Monterey, the Save button is highlighted, but the return key doesn't activate. The .cancelAction mechanism works as expected (hitting escape cancels).
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .fixedSize()
        .onAppear {
            folder = appState.selectedFolder ?? appState.folders.first!
        }
    }

    private func saveProject() {
        Task {
            let project = Project(name: name, folder: folder)
            await appState.save(project: project)
        }
    }
}
