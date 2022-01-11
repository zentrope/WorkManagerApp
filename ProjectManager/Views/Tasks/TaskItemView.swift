//
//  TaskItemView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct TaskItemView: View {

    var project: Project
    var task: ProjectTask
    var onToggle: (ProjectTask) -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            TaskCheckbox(task: task, project: project)
                .onTapGesture { onToggle(task) }
                .onHover(perform: updateCursor)
            TaskDetail(task: task, project: project)
        }
    }

    private func updateCursor(_ inside: Bool) {
        guard !project.isCompleted else { return }

        if inside {
            NSCursor.pointingHand.push()
        } else {
            NSCursor.pop()
        }
    }
}

fileprivate struct TaskDetail: View {

    var task: ProjectTask
    var project: Project

    var body: some View {
        Group {
            Text(task.name)
            // If I allow textSelection, the context menu doesn't work.
                // .textSelection(.enabled)
            Spacer()
            DateView(date: task.dateCompleted, format: .nameMonthDayYear, ifNil: "")
                .font(.caption)
        }
        .foregroundColor(task.isCompleted || project.isCompleted ? .secondary : Color(nsColor: .textColor))
        .opacity(task.isCompleted || project.isCompleted ? 0.5 : 1.0)
    }
}

fileprivate struct TaskCheckbox: View {

    var task: ProjectTask
    var project: Project

    var body: some View {
        Image(systemName: task.isCompleted ? "circle.inset.filled" : "circle")
            .foregroundColor(task.isCompleted || project.isCompleted ? .secondary : .orange)
            .opacity(task.isCompleted || project.isCompleted  ? 0.5 : 1.0)
            .font(.title2)
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        let project = Project(name: "Daily chores", folder: Folder(name: "House"))
        let task = ProjectTask(name: "Walk the dog.", completed: false)
        TaskItemView(project: project, task: task, onToggle: { task in })
    }
}
