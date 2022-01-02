//
//  ProjectListItem.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectListItem: View {

    var project: Project

    var body: some View {
        Label {
            Text(project.name)
                .badge(project.tasks.count == 0 ? 0 : project.todoCount)
        } icon: {
            ProjectStatusIcon(done: project.doneCount, total: project.tasks.count)
        }
        .padding(.vertical, 4)
    }
}
