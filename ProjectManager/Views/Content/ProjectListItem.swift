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
            StatusIcon()
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private func StatusIcon() -> some View {
        switch project.doneCount {
            case 0:
                Image(systemName: "circle")
            case project.tasks.count:
                Image(systemName: "circle.inset.filled")
            default:
                Image(systemName: "circle.bottomhalf.filled")
        }
    }
}
