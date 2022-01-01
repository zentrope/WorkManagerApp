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

    @Binding var name: String
    @Binding var doSave: Bool

    var folderName: String

    @Environment(\.dismiss) private var dismiss

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
                        .onSubmit {
                            doSave = true
                            dismiss()
                        }
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Folder:")
                        .frame(width: 64, alignment: .trailing)
                    Text(folderName)
                        .frame(width: 300, alignment: .leading)
                        .foregroundColor(.secondary)
                }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    doSave = false
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    doSave = true
                    dismiss()
                }
                // On MacOS 12 Monterey, the Save button is highlighted, but the return key doesn't activate. The .cancelAction mechanism works as expected (hitting escape cancels).
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .fixedSize()
    }
}
