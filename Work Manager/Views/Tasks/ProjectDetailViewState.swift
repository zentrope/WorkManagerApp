//
//  ProjectDetailViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation
import Combine
import OSLog

fileprivate let log = Logger("ProjectDetailViewState")

@MainActor
class ProjectDetailViewState: NSObject, ObservableObject {

    @Published var project: Project
    @Published var notes = ""
    @Published var error: Error?
    @Published var hasError = false

    private var subscribers = Set<AnyCancellable>()

    init(preview project: Project) {
        self.project = project
        self.notes = project.notes.string
        super.init()
    }

    init(project: Project) {
        self.project = project
        self.notes = project.notes.string
        super.init()
        self.$notes
            .debounce(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] newNotes in
                guard let self = self else { return }
                if self.project.notes.string != newNotes {
                    self.update(note: newNotes)
                }
            }
            .store(in: &subscribers)

        reload()

        // TODO: Use fetched results controller to avoid cloudkit churn.
        // TODO: https://stackoverflow.com/a/40375966
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextObjectsDidChange, object: PersistenceController.shared.container.viewContext, queue: .main) { [weak self] msg in
            self?.reload()
        }
    }

    func delete(task: ProjectTask) {
        Task {
            do {
                try await PersistenceController.shared.delete(task: task.id)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func rename(task: ProjectTask, name: String) {
        Task {
            do {
                try await PersistenceController.shared.update(task: task, name: name)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func save(task: ProjectTask) {
        Task {
            do {
                try await PersistenceController.shared.add(task: task, to: project)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func toggle(project: Project) {
        Task {
            do {
                try await PersistenceController.shared.toggle(project: project)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func toggle(task: ProjectTask) {
        Task {
            do {
                try await PersistenceController.shared.toggle(task: task)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func update(note: NSAttributedString) {
        Task {
            do {
                log.debug("Updating note for project '\(self.project.name)'.")
                try await PersistenceController.shared.update(project: project.id, withNote: note)
            } catch (let error) {
                log.error("\(error.localizedDescription)")
                set(error: error)
            }
        }
    }

    func update(note: String) {
        update(note: NSAttributedString(string: note))
    }

    private func reload() {
        Task {
            do {
                let mo = try await PersistenceController.shared.find(project: project.id)
                self.project = Project(mo: mo)
                self.notes = project.notes.string
            } catch (let error) {
                set(error: error)
            }
        }
    }

    private func set(error: Error) {
        self.error = error
        self.hasError = true
        log.error("\(error.localizedDescription)")
    }
}
