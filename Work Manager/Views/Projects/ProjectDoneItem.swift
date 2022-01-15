//
//  ProjectDoneItem.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/2/22.
//

import SwiftUI

struct ProjectDoneItem: View {

    var project: Project

    var body: some View {
        Label {
            HStack(alignment: .center) {
                Text(project.name)
                Spacer()
                DateView(date: project.dateCompleted, format: .dateNameShort)
                    .font(.caption)
            }
            .lineLimit(1)
            .foregroundColor(.secondary)
        } icon: {
            Image(systemName: "circle.inset.filled")
        }
        .padding(.vertical, 4)
        .lineLimit(1)
    }
}
