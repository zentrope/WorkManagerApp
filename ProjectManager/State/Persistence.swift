//
//  Persistence.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import CoreData
import OSLog

// https://www.avanderlee.com/swift/constraints-core-data-entities/

struct PersistenceController {

    static let shared = PersistenceController()

    private let logger = Logger( "PersistenceController")

    let container: NSPersistentCloudKitContainer

    private var updateContext: NSManagedObjectContext

    init() {
        let container = NSPersistentCloudKitContainer(name: "ProjectManager")
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.automaticallyMergesChangesFromParent = true

            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.container = container
        self.updateContext = container.newBackgroundContext()
        self.updateContext.automaticallyMergesChangesFromParent = true
        self.updateContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }

    /// Create a new folder.
    func insert(folder: Folder) async throws {
        logger.debug("Upserting \(folder)")
        try await updateContext.perform(schedule: .enqueued) {
            let folderMO = FolderMO(context: updateContext)
            folderMO.id = folder.id
            folderMO.name = folder.name
            try updateContext.save()
        }
    }

    /// Create a project
    func insert(project: Project) async throws {
        logger.debug("Upserting \(project)")

        let folderMO = try await find(folder: project.folder.id, context: updateContext)

        try await updateContext.perform(schedule: .enqueued) {
            let projectMO = ProjectMO(context: updateContext)
            projectMO.id = project.id
            projectMO.name = project.name
            projectMO.isCompleted = project.isCompleted
            projectMO.dateCompleted = project.dateCompleted
            projectMO.folder = folderMO
            try updateContext.save()
        }
    }

    /// Create a project task
    func add(task: ProjectTask, to project: Project) async throws {
        logger.debug("Upserting \(task)")
        let projectMO = try await find(project: project.id, context: updateContext)

        try await updateContext.perform(schedule: .enqueued) {
            let taskMO = TaskMO(context: updateContext)
            taskMO.id = task.id
            taskMO.name = task.name
            taskMO.isCompleted = task.isCompleted
            taskMO.dateCompleted = task.dateCompleted
            taskMO.project = projectMO
            try updateContext.save()
        }
    }

    // MARK: - Queries

    private func find(folder id: UUID, context: NSManagedObjectContext) async throws -> FolderMO {
        try await context.perform {
            let request = FolderMO.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            let folder = try context.fetch(request).first!
            return folder
        }
    }

    private func find(project id: UUID, context: NSManagedObjectContext) async throws -> ProjectMO {
        try await context.perform {
            let request = ProjectMO.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            let project = try context.fetch(request).first!
            return project
        }
    }

    func find(project id: UUID) async throws -> ProjectMO {
        try await find(project: id, context: container.viewContext)
    }
}
