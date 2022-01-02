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
            if (task.isCompleted) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.secondary)
                    .font(.title2.weight(.heavy))
                    .onTapGesture {
                        onToggle(task)
                    }
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.orange)
                    .font(.title2.weight(.heavy))
                    .onTapGesture {
                        onToggle(task)
                    }
            }
            Group {
                Text(task.name)
                Spacer()
                DateView(date: task.dateCompleted, format: .nameMonthDayYear, ifNil: "")
                    .font(.caption)
            }
            .foregroundColor(task.isCompleted ? .secondary : Color(nsColor: .textColor))
        }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        let task = ProjectTask(name: "Walk the dog.", completed: true)
        TaskItemView(task: task, onToggle: { task in })
    }
}
