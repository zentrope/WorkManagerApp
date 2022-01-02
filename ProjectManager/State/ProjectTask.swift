//
//  ProjectTask.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation

struct ProjectTask: Identifiable, Hashable, CustomStringConvertible {
    var id: UUID
    var name: String
    var dateCompleted: Date?
    var isCompleted: Bool

    var description: String {
        #"ProjectTask(id: \#(id), name: "\#(name)", dateCompleted: \#(String(describing: dateCompleted)), isCompleted: \#(isCompleted))"#
    }

    /// Make a ProjectTask with the given name, a generated ID and a not-completed status.
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.isCompleted = false
        self.dateCompleted = nil
    }

    /// A constructor for previews to simulate completed tasks.
    init(name: String, completed: Bool) {
        self.id = UUID()
        self.name = name
        self.isCompleted = true
        self.dateCompleted = Date()
    }

    /// Make a ProjectTask based on the TaskMO, a Core Data Managed Object.
    init(mo: TaskMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Undefined name"
        self.dateCompleted = mo.dateCompleted
        self.isCompleted = mo.isCompleted
    }
}
