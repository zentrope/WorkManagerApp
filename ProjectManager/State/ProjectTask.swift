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
    //var project: Project?
    
    var description: String {
        #"ProjectTask(id: \#(id), name: "\#(name)", dateCompleted: \#(String(describing: dateCompleted)), isCompleted: \#(isCompleted))"#
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.isCompleted = false
        self.dateCompleted = nil
    }
    
    init(mo: TaskMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Undefined name"
        self.dateCompleted = mo.dateCompleted
        self.isCompleted = mo.isCompleted
//        if let project = mo.project {
//            self.project = Project(mo: project)
//        }
    }
}
