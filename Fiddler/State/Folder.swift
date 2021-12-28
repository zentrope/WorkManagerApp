//
//  Folder.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation

struct Folder: Identifiable, CustomStringConvertible {
    var id: UUID
    var name: String

    var description: String {
        return #"{ id: "\#(id)", name: "\#(name)" }"#
    }

    init(name: String) {
        self.id = UUID()
        self.name = name
    }

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    init(mo: FolderMO) {
        self.id = mo.id ?? UUID()
        self.name = mo.name ?? "Folder \(self.id)"
    }
}
