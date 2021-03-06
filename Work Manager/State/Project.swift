//
//  Project.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation
import OSLog

fileprivate let log = Logger("Project")

struct Project: Identifiable, Hashable, CustomStringConvertible {
    var id: UUID
    var name: String
    var isCompleted: Bool
    var dateCompleted: Date?
    var notes: NSAttributedString
    var folder: Folder
    var tasks: [ProjectTask]

    var doneCount: Int = 0
    var todoCount: Int = 0

    var doneTasks: [ProjectTask] = []
    var todoTasks: [ProjectTask] = []

    var description: String {
        return #"Project(id: \#(id), name: "\#(name)", isCompleted: \#(isCompleted), dateCompleted: \#(String(describing: dateCompleted)), folder: \#(String(describing: folder)))"#
    }

    /// Make a new project.
    init(name: String, folder: Folder, tasks: [ProjectTask] = []) {
        self.id = UUID()
        self.name = name
        self.isCompleted = false
        self.dateCompleted = nil
        self.notes = NSAttributedString(string: "")
        self.folder = folder
        self.tasks = tasks
        self.doneCount = tasks.filter { $0.isCompleted }.count
        self.todoCount = self.tasks.count - self.doneCount
        self.doneTasks = self.tasks.filter { $0.isCompleted }
        self.todoTasks = self.tasks.filter { !$0.isCompleted }
    }

    /// Make a Project based on the persisted Core Data ProjectMO Managed Object.
    init(mo: ProjectMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Project \(self.id)"
        self.isCompleted = mo.isCompleted
        self.dateCompleted = mo.dateCompleted
        self.notes = mo.notes ?? NSAttributedString(string: "")

        // This is a hack to prevent a circular dependency graph.
        if let folder = mo.folder,
           let name = folder.name,
           let id = folder.id {
            self.folder = Folder(id: id, name: name)
        } else {
            self.folder = Folder.noFolder
        }

        self.tasks = mo.wrappedTasks.map { .init(mo: $0) }

        self.doneCount = tasks.filter { $0.isCompleted }.count
        self.todoCount = self.tasks.count - self.doneCount
        self.doneTasks = self.tasks.filter { $0.isCompleted }
        self.todoTasks = self.tasks.filter { !$0.isCompleted }
    }
}

extension ProjectMO {

    var wrappedTasks: [TaskMO] {
        let array = tasks?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [TaskMO]
        if let values = array {
            return values
        }
        return []
    }
}
