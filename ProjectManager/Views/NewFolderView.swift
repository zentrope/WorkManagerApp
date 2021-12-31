//
//  NewFolderView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import SwiftUI

struct NewFolderView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState

    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "folder.badge.plus")
                    .foregroundColor(.teal)
                    .font(.title)
                Text("New folder")
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
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    Task { await appState.save(folder: Folder(name: name)) }
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
