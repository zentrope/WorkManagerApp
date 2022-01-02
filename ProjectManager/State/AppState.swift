//
//  AppState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/27/21.
//

import Foundation
import OSLog

fileprivate let logger = Logger("AppState")

final class AppState: NSObject, ObservableObject {

    @Published var error: Error?
    @Published var hasError = false

    override init() {
        super.init()
    }

    func save(task: ProjectTask, in project: Project) async {
        do {
            try await PersistenceController.shared.add(task: task, to: project)
        } catch (let error) {
            logger.error("\(error.localizedDescription)")
            set(error: error)
        }
    }

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }
}
