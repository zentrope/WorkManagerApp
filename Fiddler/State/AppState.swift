//
//  AppState.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import CoreData
import OSLog

class AppState: NSObject, ObservableObject {

    @Published var status = [Status]()
    @Published var selectedStatus: Int? = 1

    @Published var folders = [Folder]()
    @Published var selectedFolder: Folder?

    @Published var error: Error?
    @Published var hasError = false

    private let logger = Logger("AppState")

    private lazy var statusCursor: NSFetchedResultsController<StatusMO> = {
        let fetcher = StatusMO.fetchRequest()
        fetcher.sortDescriptors = [ NSSortDescriptor(key: "id", ascending: true)]
        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cursor.delegate = self
        return cursor
    }()

    private lazy var folderCursor: NSFetchedResultsController<FolderMO> = {
        let fetcher = FolderMO.fetchRequest()
        fetcher.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]
        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
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

    @MainActor
    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }

    private func reload() {
        do {
            try statusCursor.performFetch()
            status = (statusCursor.fetchedObjects ?? []).map { .init(mo: $0) }

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
