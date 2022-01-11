//
//  ProjectDetailViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation
import OSLog

fileprivate let log = Logger("ProjectDetailViewState")

@MainActor
class ProjectDetailViewState: NSObject, ObservableObject {

    @Published var project: Project
    @Published var error: Error?
    @Published var hasError = false

    init(preview project: Project) {
        self.project = project
        super.init()
    }

    init(project: Project) {
        self.project = project
        log.debug("Initializing project: [\(project.name)]")
        super.init()
        reload()
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: .main) { [weak self] msg in
            log.debug("In callback, noticed that something has changed: \(msg)")
            self?.reload()
        }
    }

    func rename(task: ProjectTask, name: String) {
        Task {
            do {
                try await PersistenceController.shared.update(task: task, name: name)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    func save(task: ProjectTask) {
        Task {
            do {
                try await PersistenceController.shared.add(task: task, to: project)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    func toggle(project: Project) {
        Task {
            do {
                try await PersistenceController.shared.toggle(project: project)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    func toggle(task: ProjectTask) {
        Task {
            do {
                try await PersistenceController.shared.toggle(task: task)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    private func reload() {
        Task {
            do {
                let mo = try await PersistenceController.shared.find(project: project.id)
                set(project: Project(mo: mo))
            } catch (let error) {
                set(error: error)
            }
        }
    }

    private func set(project: Project) {
        self.project = project
    }

    private func set(error: Error) {
        self.error = error
        self.hasError = true
    }
}
