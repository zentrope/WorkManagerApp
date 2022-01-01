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
            try await PersistenceController.shared.insert(project: project)
            await set(selected: name)
        } catch (let error) {
            log.error("\(error.localizedDescription)")
            set(error: error)
        }
    }

    func delete(project: Project) async {
        do {
            if project.name == selectedProject {
                await set(selected: nil)
            }
            try await PersistenceController.shared.delete(project: project)
        } catch (let error) {
            log.debug("\(error.localizedDescription)")
            set(error: error)
        }
    }

    @MainActor
    private func set(selected: String?) {
        self.selectedProject = selected
    }

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }

}
