//
//  NewProjectView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct NewProjectView: View {

    @Environment(\.dismiss) var dismiss
    @State private var name = ""

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
                        .frame(width: 64)
                    TextField("Project name", text: $name)
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

struct NewProjectView_Previews: PreviewProvider {
    static var previews: some View {
        NewProjectView()
    }
}
