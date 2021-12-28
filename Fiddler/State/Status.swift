//
//  Status.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation

struct Status: Identifiable, CustomStringConvertible {
    var id: Int
    var name: String

    var description: String {
        return #"Status(id: \#(id), name: "\#(name)")"#
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    init(mo: StatusMO) {
        self.id = Int(mo.id)
        self.name = mo.name ?? "Status \(self.id)"
    }
}
