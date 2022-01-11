//
//  SidebarViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/31/21.
//

import Combine
import CoreData
import OSLog

fileprivate let log = Logger("SidebarViewState")

final class SidebarViewState: NSObject, ObservableObject {

    @Published var folders = [SidebarItem]()
    @Published var error: Error?
    @Published var hasError = false

    private lazy var cursor: NSFetchedResultsController<FolderMO> = {
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

    func delete(folder id: UUID) {
        Task {
            do {
                try await PersistenceController.shared.delete(folder: id)
            } catch (let error) {
                set(error: error)
            }
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

    func rename(folder id: UUID, name: String) {
        let newName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if newName.isEmpty {
            return
        }
        Task {
            do {
                try await PersistenceController.shared.update(folder: id, name: newName)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    private func reload() {
        do {
            try cursor.performFetch()
            self.folders = (cursor.fetchedObjects ?? []).map { .init(folder: $0) }
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
        log.debug("Reloading due to a cursor change notification.")
        reload()
    }
}
