//
//  RenameStringView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/5/22.
//

import SwiftUI

struct RenameStringView: View {
    @Environment(\.dismiss) private var dismiss

    var title: String
    var prompt: String
    var systemName: String

    @Binding var text: String
    @Binding var commit: Bool

    var body: some View {
        VStack(spacing: 20) {

            HStack(alignment: .center) {
                Image(systemName: systemName)
                    .foregroundColor(.accentColor)
                    .font(.title)
                Text(title)
                    .bold()
                Spacer()
            }

            Form {
                TextField(prompt, text: $text)
                    .onSubmit {
                        dismiss(true)
                    }
            }

            HStack(alignment: .center, spacing: 10) {
                Spacer()
                Button("Cancel") { dismiss(false) }
                .keyboardShortcut(.cancelAction)
                Button("Update") { dismiss(true) }
                .keyboardShortcut(.defaultAction)
            }

        }
        .padding()
        .frame(width: 400)
    }

    func dismiss(_ commit: Bool) {
        self.commit = commit
        dismiss()
    }
}
