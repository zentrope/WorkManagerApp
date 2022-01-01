//
//  ProjectContentViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/31/21.
//

import Foundation
import OSLog

fileprivate let log = Logger("ProjectContentViewState")

class ProjectContentViewState: NSObject, ObservableObject {

    @Published var selectedProject: String?
    @Published var error: Error?
    @Published var hasError = false

    override init() {
        super.init()
    }

    func saveProject(name: String, folder: Folder) async {
        do {
            let project = Project(name: name, folder: folder)
            log.debug("Saving \(project)")
            try await PersistenceController.shared.insert(project: project)
            log.debug("Saved without exception")
            await set(selected: name)
        } catch (let error) {
            log.error("\(error.localizedDescription)")
            set(error: error)
        }
    }

    @MainActor
    private func set(selected: String) {
        self.selectedProject = selected
    }

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }

}
