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

    // Must be 2 of these because we have two ForEach sets of NavLinks and it's possible that the underlying database will move the selected project from one group to the other. If the selection used to be in one ForEach, but isn't on a refresh, the selection is cleared out (because the thing that was selected isn't there).
    @Published var selectedTodo: String?
    @Published var selectedDone: String?
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

    func toggle(project: Project) {
        Task {
            do {
                try await PersistenceController.shared.toggle(project: project)
                await set(selected: project.name)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    func swapSelections() {
        if let todo = selectedTodo {
            selectedDone = todo
        } else if let done = selectedDone {
            selectedTodo = done
        }
    }

    func delete(project: Project) {
        if project.name == selectedTodo || project.name == selectedDone {
            log.debug("Setting selectProject to nil")
            selectedTodo = nil
            selectedDone = nil
        }
        Task {
            do {
                try await PersistenceController.shared.delete(project: project)
            } catch (let error) {
                log.debug("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    @MainActor
    private func set(selected: String?) {
        // Only one of the lists will have the selected project name, so it's ok to set both.
        selectedDone = selected
        selectedTodo = selected
    }

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }
}
