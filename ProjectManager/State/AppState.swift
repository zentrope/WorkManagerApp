//
//  AppState.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/27/21.
//

import Combine
import CoreData
import OSLog

fileprivate let logger = Logger("AppState")

final class AppState: NSObject, ObservableObject {

    // MARK: - Publishers

    @Published var selectedStatus: Status? = Status.open

    @Published var folders = [Folder]()
    @Published var selectedFolder: Folder?

    @Published var projects = [Project]()

    @Published var error: Error?
    @Published var hasError = false

    enum Status: String, CaseIterable {
        case open = "Open"
        case completed = "Completed"
    }

    // MARK: - Local State

    private lazy var folderCursor: NSFetchedResultsController<FolderMO> = {
        let fetcher = FolderMO.fetchRequest()
        fetcher.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true)]

        let cursor = NSFetchedResultsController(fetchRequest: fetcher, managedObjectContext: PersistenceController.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        cursor.delegate = self
        return cursor
    }()

    private lazy var projectCursor: NSFetchedResultsController<ProjectMO> = {

        let fetcher = ProjectMO.fetchRequest()
        fetcher.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        fetcher.predicate = NSPredicate(format: "isComplete = false")

        let cursor = NSFetchedResultsController(
            fetchRequest: fetcher,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        cursor.delegate = self
        return cursor
    }()

    private var subscribers = Set<AnyCancellable>()

    // MARK: - Initializers

    override init() {
        super.init()

        $selectedFolder
            .sink { [weak self] newFolder in self?.filterProject(on: newFolder) }
            .store(in: &subscribers)

        $selectedStatus
            .sink { [weak self] newStatus in self?.filterProject(on: newStatus) }
            .store(in: &subscribers)

        reload()
    }

    // MARK: - Mutators

    func save(folder: Folder) async {
        do {
            try await PersistenceController.shared.insert(folder: folder)
        } catch (let error) {
            set(error: error)
        }
    }

    func save(project: Project) async {
        do {
            try await PersistenceController.shared.insert(project: project)
        } catch (let error) {
            logger.error("\(error.localizedDescription)")
            set(error: error)
        }
    }

    func save(task: ProjectTask, in project: Project) async {
        do {
            try await PersistenceController.shared.add(task: task, to: project)
        } catch (let error) {
            logger.error("\(error.localizedDescription)")
            set(error: error)
        }
    }

    // MARK: - Implementation Details

    private func set(error: Error) {
        self.hasError = true
        self.error = error
    }

    private func filterProject(on folder: Folder?) {
        guard let folder = folder else { return }

        projectCursor.fetchRequest.predicate = NSPredicate(format: "folder.name = %@", folder.name)
        reload()
    }

    private func filterProject(on status: Status?) {
        guard let status = status else { return }

        let condition = (status == .open ? "false" : "true")
        projectCursor.fetchRequest.predicate = NSPredicate(format: "isCompleted = " + condition)
        reload()
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

// MARK: - Delegates

extension AppState: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        reload()
    }
}
