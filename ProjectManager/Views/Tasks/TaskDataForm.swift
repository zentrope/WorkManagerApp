//
//  NewTaskView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct TaskDataForm: View {

    var isEdit: Bool
    @Binding var name: String
    @Binding var ok: Bool

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: isEdit ? "square.and.pencil" : "text.badge.plus")
                    .foregroundColor(.teal)
                    .font(.title)
                Text("\(isEdit ? "Update" : "Create") task")
                    .bold()
                Spacer()
            }

            Form {
                TextField("Task:", text: $name)
                    .textFieldStyle(.squareBorder)
                    .onSubmit { // hack due to .defaultAction not working on MacOS 12.1
                        handleSubmit(doSave: true)
                    }
            }

            HStack(alignment: .center, spacing: 20) {
                Spacer()
                Button("Cancel") {
                    handleSubmit(doSave: false)
                }
                .keyboardShortcut(.cancelAction)
                Button(isEdit ? "Update" : "Create") {
                    handleSubmit(doSave: true)
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding()
        .frame(width: 500)
    }

    private func handleSubmit(doSave: Bool) {
        ok = doSave
        dismiss()
    }
}

struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDataForm(isEdit: true, name: .constant("Take out the garbage."), ok: .constant(true))
    }
}
