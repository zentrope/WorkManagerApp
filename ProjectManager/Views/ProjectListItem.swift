//
//  ProjectListItem.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectListItem: View {

// @TODO: Commented out section shows how to approach inline editing.

    var project: Project

    var body: some View {
        Label {
            HStack(alignment: .center) {
                Text(project.name)
                    .lineLimit(1)
                Spacer()
                Text(project.folder.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

            }
        } icon: {
            Image(systemName: "folder")
        }
        .padding(.vertical, 4)
    }
}
