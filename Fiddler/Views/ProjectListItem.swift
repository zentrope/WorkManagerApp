//
//  ProjectListItem.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectListItem: View {

// @TODO: Commented out section shows how to approach inline editing.

    var project: Project
//    @State var name = ""
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Image(systemName: project.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(project.isCompleted ? .accentColor : .orange)
                .font(Font.headline)
//            TextField("name", text: $name) { flag in
//                print("Editing Changed: flag = \(flag)")
//            }
            Text(project.name)
                .lineLimit(1)
            Spacer()
            Text(project.folder.name)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(.vertical, 4)
//        .onAppear { name = project.name }
    }
}
