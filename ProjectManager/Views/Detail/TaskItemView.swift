//
//  TaskItemView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct TaskItemView: View {
    var task: ProjectTask
    var onToggle: (ProjectTask) -> Void
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: task.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(task.isCompleted ? .secondary : .orange)
                .opacity(task.isCompleted ? 0.5 : 1.0)
                .font(.title2)
                .onTapGesture {
                    onToggle(task)
                }
                .onHover(perform: updateCursor)
            Group {
                Text(task.name)
                Spacer()
                DateView(date: task.dateCompleted, format: .nameMonthDayYear, ifNil: "")
                    .font(.caption)
            }
            .foregroundColor(task.isCompleted ? .secondary : Color(nsColor: .textColor))
            .opacity(task.isCompleted ? 0.5 : 1.0)
        }
    }

    private func updateCursor(_ inside: Bool) {
        if inside {
            NSCursor.pointingHand.push()
        } else {
            NSCursor.pop()
        }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        let task = ProjectTask(name: "Walk the dog.", completed: true)
        TaskItemView(task: task, onToggle: { task in })
    }
}
