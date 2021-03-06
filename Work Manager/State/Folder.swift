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
    var numProducts: Int = 0
    var numAvailable: Int = 0
    var numCompleted: Int = 0

    var description: String {
        #"Folder(id: \#(id), name: "\#(name)", products: \#(numProducts), available: \#(numAvailable), completed: \#(numCompleted))"#
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
    }

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    init(folderMO: FolderMO) {
        self.id = folderMO.id ?? UUID()
        self.name = folderMO.name ?? "Folder \(self.id)"
        let projects = folderMO.wrappedProjects

        numProducts = projects.count
        numAvailable = projects.filter { !$0.isCompleted }.count
        numCompleted = numProducts - numAvailable
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
