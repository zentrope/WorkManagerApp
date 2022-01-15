//
//  FolderForm.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import SwiftUI

struct FolderForm: View {

    enum Mode {
        case create, update

        var systemName: String {
            switch self {
                case .create: return "folder.badge.plus"
                case .update: return "folder.badge.gear"
            }
        }

        var title: String {
            switch self {
                case .create: return "New folder"
                case .update: return "Update folder"
            }
        }
    }

    @Environment(\.dismiss) private var dismiss

    var mode: Mode
    @Binding var name: String
    @Binding var ok: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: mode.systemName)
                    .foregroundColor(.teal)
                    .font(.title)
                Text(mode.title)
                    .bold()
                Spacer()
            }

            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 10) {
                    Text("Folder:")
                        .frame(width: 64)
                    TextField("Folder name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 300)
                }
                .onSubmit {
                    handleCommit(doSave: true)
                }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    handleCommit(doSave: false)
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    handleCommit(doSave: true)
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .fixedSize()
    }

    private func handleCommit(doSave: Bool) {
        ok = doSave
        dismiss()

    }
}
