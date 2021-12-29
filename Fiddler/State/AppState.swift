//
//  AppState.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import CoreData
import OSLog

fileprivate let logger = Logger("AppState")

final class AppState: NSObject, ObservableObject {

    @Published var selectedStatus: Status? = Status.open

    @Published var folders = [Folder]()
    @Published var selectedFolder: Folder?

    @Published var projects = [Project]()
    @Published var selectedProject: Project?

    @Published var error: Error?
    @Published var hasError = false

    enum Status: String, CaseIterable {
        case open = "Open"
        case completed = "Completed"
    }

    private lazy var folderCursor: NSFetchedResultsController<FolderMO> = {
        let fetcher = FolderMO.fetchRequest()
        fetcher.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cursor.delegate = self
        return cursor
    }()

    private lazy var projectCursor: NSFetchedResultsController<ProjectMO> = {

        let fetcher = ProjectMO.fetchRequest()

        fetcher.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]

        let cursor = NSFetchedResultsController(
            fetchRequest: fetcher,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        cursor.delegate = self
        return cursor
    }()

    override init() {
        super.init()
        reload()
    }

    func save(folder: Folder) async {
        do {
            try await PersistenceController.shared.insert(folder: folder)
        } catch (let error) {
            await set(error: error)
        }
    }

    func save(project: Project) async {
        do {
            try await PersistenceController.shared.insert(project: project)
        } catch (let error) {
            logger.error("\(error.localizedDescription)")
            await set(error: error)
        }
    }

    @MainActor
    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }

    private func reload() {
        do {
            try projectCursor.performFetch()
            projects = (projectCursor.fetchedObjects ?? []).map { .init(mo: $0 ) }

            try folderCursor.performFetch()
            folders = (folderCursor.fetchedObjects ?? []).map { .init(mo: $0) }
        } catch (let error) {
            logger.error("\(error.localizedDescription)")
        }
    }
}

extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reload()
    }
}