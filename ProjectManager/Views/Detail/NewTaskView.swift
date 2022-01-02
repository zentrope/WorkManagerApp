//
//  NewTaskView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct NewTaskView: View {

    @Environment(\.dismiss) private var dismiss

    var project: String
    var folder: String

    @Binding var name: String
    @Binding var ok: Bool

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
                        .onSubmit { // hack due to .defaultAction not working on MacOS 12.1
                            handleSubmit(doSave: true)
                        }
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Project:")
                        .frame(width: 94, alignment: .trailing)
                    Text(project)
                        .foregroundColor(.secondary)
                        .frame(width: width, alignment: .leading)
                }

                HStack(alignment: .center, spacing: 10) {
                    Text("Folder:")
                        .frame(width: 94, alignment: .trailing)
                    Text(folder)
                        .foregroundColor(.secondary)
                        .frame(width: width, alignment: .leading)
                }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    handleSubmit(doSave: false)
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    handleSubmit(doSave: true)
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .fixedSize()
    }

    private func handleSubmit(doSave: Bool) {
        ok = doSave
        dismiss()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(project: "Test Project", folder: "Chores", name: .constant("Take out the garbage."), ok: .constant(true))
    }
}
