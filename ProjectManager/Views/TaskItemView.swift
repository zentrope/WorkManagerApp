//
//  TaskItemView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/30/21.
//

import SwiftUI

struct TaskItemView: View {
    var task: ProjectTask

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if (task.isCompleted) {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.accentColor)
                    .font(.title2.weight(.heavy))
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.orange)
                    .font(.title2.weight(.heavy))
            }
            Text(task.name)

            Spacer()
            DateView(date: task.dateCompleted, format: .nameMonthDayYear, ifNil: "")
        }
    }
}

struct TaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        let task = ProjectTask(name: "Walk the dog.")
        TaskItemView(task: task)
    }
}
