//
//  Folder.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation
import OSLog

fileprivate let log = Logger("Folder")

struct Folder: Identifiable, CustomStringConvertible, Hashable {
    var id: UUID
    var name: String
    var projects: [Project]

    var done: [Project]
    var todo: [Project]

    var description: String {
        #"Folder(id: \#(id), name: "\#(name)", projects: \#(projects.count))"#
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.projects = []
        self.done = []
        self.todo = []
    }

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        self.projects = []
        self.done = []
        self.todo = []
    }

    init(folderMO: FolderMO) {
        self.id = folderMO.id ?? UUID()
        self.name = folderMO.name ?? "Folder \(self.id)"
        self.projects = folderMO.wrappedProjects.map { Project(mo: $0)}
        self.done = self.projects.filter { $0.isCompleted }
        self.todo = self.projects.filter { !$0.isCompleted }
    }

    static let noFolder = Folder(name: "Null")
}

extension FolderMO {

    var wrappedProjects: [ProjectMO] {
        let array = projects?.sortedArray(using: [NSSortDescriptor(key: "name", ascending: true)]) as? [ProjectMO]
        if let values = array {
            return values
        }
        return []
    }
}
