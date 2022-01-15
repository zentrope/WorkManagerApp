//
//  ProjectFormView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import OSLog

fileprivate let logger = Logger("ProjectFormView")

struct ProjectFormView: View {

    var folders: [ProjectListViewState.Folder]

    @Binding var name: String
    @Binding var folder: UUID
    @Binding var commit: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Title()

            Form {
                TextField("Name:", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { submit(doCommit: true)}

                Spacer().frame(height: 20)
                Picker("Folder:", selection: $folder) {
                    ForEach(folders, id: \.id) { folder in
                        Text(folder.name).tag(folder.id)
                    }
                }
                .fixedSize()
            }

            Commands()
        }
        .padding()
        .frame(width: 400)
    }

    @ViewBuilder
    private func Title() -> some View {
        HStack {
            Image(systemName: "folder.badge.plus")
                .foregroundColor(.mint)
                .font(.title)
            Text("Add a new project")
                .bold()
            Spacer()
        }
    }

    @ViewBuilder
    private func Commands() -> some View {
        HStack(alignment: .center, spacing: 10) {
            Spacer()

            Button("Cancel") { submit(doCommit: false) }
            .keyboardShortcut(.cancelAction)

            Button("Save") { submit(doCommit: true) }
            .keyboardShortcut(.defaultAction)
            .disabled(name.isEmpty || folders.isEmpty)
        }
    }

    private func submit(doCommit: Bool) {
        self.commit = doCommit
        self.dismiss()
    }
}
