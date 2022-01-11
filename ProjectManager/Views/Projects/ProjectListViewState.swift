//
//  ProjectListViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/5/22.
//

import CoreData
import OSLog

fileprivate let log = Logger("ProjectListViewState")

final class ProjectListViewState: NSObject, ObservableObject {

    @Published var projects = [Project]()
    @Published var todos = [Project]()
    @Published var dones = [Project]()
    @Published var folders = [Folder]()
    @Published var error: Error?
    @Published var hasError = false

    private lazy var projectCursor: NSFetchedResultsController<ProjectMO> = {
        let fetcher = ProjectMO.fetchRequest()
        fetcher.sortDescriptors = [
            NSSortDescriptor(key: "isCompleted", ascending: true),
            NSSortDescriptor(key: "dateCompleted", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)]
        fetcher.predicate = NSPredicate(format: "isCompleted = false")
        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cursor.delegate = self
        return cursor
    }()

    private lazy var folderCursor: NSFetchedResultsController<FolderMO> = {
        let fetcher = FolderMO.fetchRequest()
        fetcher.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cursor.delegate = self
        return cursor
    }()

    override init() {
        super.init()
    }

    func set(filter: SidebarItem) {
        projectCursor.fetchRequest.predicate = filter.predicate
        reload()
    }

    func delete(project id: UUID) {
        Task {
            do {
                try await PersistenceController.shared.delete(project: id)
            } catch (let error) {
                set(error: error)
                log.error("\(error.localizedDescription)")
            }
        }
    }

    func rename(project id: UUID, withNewName: String) {
        let name = withNewName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        Task {
            do {
                try await PersistenceController.shared.rename(project: id, withNewName: name)
            } catch (let error) {
                set(error: error)
                log.error("\(error.localizedDescription)")
            }
        }
    }

    func save(project: String, folder: UUID) {
        let name = project.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        Task {
            do {
                try await PersistenceController.shared.insert(projectNamed: name, inFolder: folder)
            } catch (let error) {
                set(error: error)
                log.error("\(error.localizedDescription)")
            }
        }
    }

    private func reload() {
        do {
            try projectCursor.performFetch()
            self.projects = (projectCursor.fetchedObjects ?? []).map { .init(mo: $0) }
            self.todos = self.projects.filter { !$0.isCompleted }
            self.dones = self.projects.filter { $0.isCompleted }
            try folderCursor.performFetch()
            self.folders = (folderCursor.fetchedObjects ?? []).map { .init(folder: $0) }
        } catch (let error) {
            set(error: error)
            log.error("\(error.localizedDescription)")
        }
    }

    private func set(error: Error) {
        self.error = error
        self.hasError = true
    }

    struct Folder: Identifiable {
        var id: UUID
        var name: String

        init(folder: FolderMO) {
            id = folder.id!
            name = folder.name!
        }
    }
}

extension ProjectListViewState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reload()
    }
}
