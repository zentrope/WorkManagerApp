//
//  FlatTaskListViewState.swift
//  Work Manager
//
//  Created by Keith Irwin on 3/6/22.
//

import Foundation
import CoreData
import OSLog

@MainActor
final class FlatTaskListViewState: NSObject, ObservableObject {

    @Published var tasks = [ProjectTask]()
    @Published var projects = [Project]()
    @Published var unselectedProject = UUID()
    @Published var showAlert = false
    @Published var error: Error?

    private lazy var cursor: NSFetchedResultsController<TaskMO> = {
        let fetcher = TaskMO.fetchRequest()

        fetcher.sortDescriptors = [
            NSSortDescriptor(key: "dateCompleted", ascending: true),
            NSSortDescriptor(key: "project.name", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]

        let cursor = NSFetchedResultsController(
            fetchRequest: fetcher,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return cursor
    }()

    override init() {
        super.init()

        Task {
            await reload()
        }
    }
}

// MARK: - Public API

extension FlatTaskListViewState {

    func setFilter(projectId: UUID?) {
        if let id = projectId {
            cursor.fetchRequest.predicate = NSPredicate(format: "project.id == %@", id as CVarArg)
        } else {
            cursor.fetchRequest.predicate = nil
        }
        reload()
    }
}

// MARK: - Private Implementation

extension FlatTaskListViewState {

    private func reload() {
        Task {
            do {
                try cursor.performFetch()
                self.tasks = (cursor.fetchedObjects ?? []).map { ProjectTask($0) }

                let projects = try PersistenceController.shared.allProjects()
                self.projects = projects.map { Project($0) }
            } catch (let e) {
                showAlert(error: e)
            }
        }
    }

    private func showAlert(error: Error) {
        self.error = error
        self.showAlert = true
    }
}

// MARK: - Presentation Objects

extension FlatTaskListViewState {

    struct ProjectTask: Identifiable {
        var id: UUID
        var isCompleted: Bool
        var name: String
        var dateCompleted: Date?
        var folder: String
        var project: String

        init(_ mo: TaskMO) {
            self.id = mo.id!
            self.name = mo.name ?? "…"
            self.dateCompleted = mo.dateCompleted
            self.isCompleted = mo.isCompleted
            self.folder = mo.project?.folder?.name ?? "no folder"
            self.project = mo.project?.name ?? "…"
        }
    }

    struct Project: Identifiable {
        var id: UUID
        var name: String
        var isCompleted: Bool

        init(_ mo: ProjectMO) {
            self.id = mo.id!
            self.name = mo.name ?? "…"
            self.isCompleted = mo.isCompleted
        }
    }

}

// MARK: - Cursor Delegate

extension FlatTaskListViewState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reload()
    }
}
