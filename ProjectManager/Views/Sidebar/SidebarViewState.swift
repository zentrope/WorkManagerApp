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
    @Published var selectedFolder: String?
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

    func delete(folder: Folder) {
        Task {
            do {
                try await PersistenceController.shared.delete(folder: folder)
                await select(folderName: folders.first?.name)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func save(folder: Folder) {
        Task {
            do {
                try await PersistenceController.shared.insert(folder: folder)
                await select(folderName: folder.name)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    func update(folder: Folder, name: String) {
        let folderToSelect = folder.name == selectedFolder ? name : selectedFolder
        Task {
            do {
                try await PersistenceController.shared.update(folder: folder, name: name)
                await select(folderName: folderToSelect)
            } catch (let error) {
                set(error: error)
            }
        }
    }

    private func reload() {
        do {
            try folderCursor.performFetch()
            folders = (folderCursor.fetchedObjects ?? []).map { .init(folderMO: $0) }
            if selectedFolder == nil {
                selectedFolder = folders.first?.name
            }
        } catch (let error) {
            set(error: error)
            log.error("\(error.localizedDescription)")
        }
    }

    @MainActor
    private func select(folderName: String?) {
        self.selectedFolder = folderName
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
