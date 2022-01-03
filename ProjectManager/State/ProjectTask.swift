//
//  ProjectTask.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation

struct ProjectTask: Identifiable, Hashable, CustomStringConvertible {
    // This value object does not provide a back reference to the actual project to avoid circular de-referencing when converting from Managed Objects. I want to keep these objects as optional-free as possible. I could provide a lazy property to run a query to get the project, but if I start doing that, I'll be half way toward re-implementing Core Data's fault system.

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
        self.isCompleted = completed
        self.dateCompleted = completed ? Date() : nil
    }

    /// Make a ProjectTask based on the TaskMO, a Core Data Managed Object.
    init(mo: TaskMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Undefined name"
        self.dateCompleted = mo.dateCompleted
        self.isCompleted = mo.isCompleted
    }
}
