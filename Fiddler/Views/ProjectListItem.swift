//
//  ProjectListItem.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectListItem: View {

    var project: Project
    var body: some View {
        HStack(alignment: .center, spacing: 6) {
            Image(systemName: project.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(project.isCompleted ? .green : .orange)
                .font(Font.headline)
            Text(project.name)
                .lineLimit(1)
            Spacer()
            Text(project.folder?.name ?? "No folder")
                .font(.caption)
                .foregroundColor(.mint)
                .lineLimit(1)

        }
        .padding(.vertical, 4)
    }
}
