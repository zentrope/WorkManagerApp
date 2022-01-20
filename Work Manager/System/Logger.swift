//
//  Logger.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import OSLog

extension Logger {

    init(_ category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier!, category: category)
    }
}
