//
//  SidebarItem.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/5/22.
//

import Foundation

struct SidebarItem: Identifiable {
    var id: UUID
    var name: String
    var predicate: NSPredicate
    var isFolder: Bool
    var count = 0
    var available = 0

    init(folder: FolderMO) {
        self.id = folder.id!
        self.name = folder.name!
        self.predicate = NSPredicate(format: "folder.name = %@", self.name)
        self.isFolder = true

        let array = folder.projects?.allObjects as? [ProjectMO] ?? []
        self.count = array.count
        self.available = array.filter { !$0.isCompleted }.count
    }

    init(id: UUID, name: String, predicate: NSPredicate, isFolder: Bool = false) {
        self.id = id
        self.name = name
        self.predicate = predicate
        self.isFolder = isFolder
        self.count = 0
    }

    static let available = SidebarItem(id: UUID(), name: "Available", predicate: NSPredicate(format: "isCompleted = false"))
    static let completed = SidebarItem(id: UUID(), name: "Completed", predicate: NSPredicate(format: "isCompleted = true"))
}
