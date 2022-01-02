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

    @State private var flashChange = false

    private var completed: Bool {
        flashChange ? !task.isCompleted : task.isCompleted
    }

    private var completedDate: Date? {
        (flashChange && task.dateCompleted != nil) ? nil : task.dateCompleted
    }

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: completed ? "circle.inset.filled" : "circle")
                .foregroundColor(completed ? .secondary : .orange)
                .opacity(completed ? 0.5 : 1.0)
                .font(.title2)
                .onTapGesture {
                    flashChange = true
                    Task {
                        try await Task.sleep(nanoseconds: 1_000_000_000 / 5)
                        onToggle(task)
                    }
                }
                .onHover(perform: updateCursor)
            Group {
                Text(task.name)
                Spacer()
                DateView(date: completedDate, format: .nameMonthDayYear, ifNil: "")
                    .font(.caption)
            }
            .foregroundColor(completed ? .secondary : Color(nsColor: .textColor))
            .opacity(completed ? 0.5 : 1.0)
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
