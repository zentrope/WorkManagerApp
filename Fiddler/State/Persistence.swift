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
        let container = NSPersistentCloudKitContainer(name: "Fiddler")
        container.loadPersistentStores { storeDescription, error in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.container = container
        self.updateContext = container.newBackgroundContext()
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
        try await updateContext.perform(schedule: .enqueued) {
            let projectMO = ProjectMO(context: updateContext)
            projectMO.id = project.id
            projectMO.name = project.name
            projectMO.isCompleted = project.isCompleted
            projectMO.dateCompleted = project.dateCompleted

            if let folder = project.folder {
                let folderMO = FolderMO(context: updateContext)
                folderMO.id = folder.id
                folderMO.name = folder.name
                projectMO.folder = folderMO
            }

            try updateContext.save()
        }
    }
}
