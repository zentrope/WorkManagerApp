//
//  SidebarViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/31/21.
//

import CoreData
import OSLog

fileprivate let log = Logger("SidebarViewState")

final class SidebarViewState: NSObject, ObservableObject {

    @Published var folders = [Folder]()
    @Published var error: Error?
    @Published var hasError = false

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

        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: .main) { [weak self] msg in
            self?.reload()
        }
    }

    func save(folder: Folder) {
        Task {
            do {
                try await PersistenceController.shared.insert(folder: folder)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    private func reload() {
        do {
            try folderCursor.performFetch()
            folders = (folderCursor.fetchedObjects ?? []).map { .init(folderMO: $0) }
        } catch (let error) {
            set(error: error)
            log.error("\(error.localizedDescription)")
        }
    }

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }
}

extension SidebarViewState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reload()
    }
}
