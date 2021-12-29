//
//  Project.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation


struct Project: Identifiable, Hashable, CustomStringConvertible {
    var id: UUID
    var name: String
    var isCompleted: Bool
    var dateCompleted: Date?
    var folder: Folder?

    var description: String {
        return #"Project(id: \#(id), name: "\#(name)", isCompleted: \#(isCompleted), dateCompleted: \#(String(describing: dateCompleted)), folder: \#(String(describing: folder)))"#
    }

    init(name: String, folder: Folder) {
        self.id = UUID()
        self.name = name
        self.isCompleted = false
        self.dateCompleted = nil
        self.folder = folder
    }

    init(mo: ProjectMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Project \(self.id)"
        self.isCompleted = mo.isCompleted
        self.dateCompleted = mo.dateCompleted

        if let folder = mo.folder {
            self.folder = Folder(mo: folder)
        }
    }
}
