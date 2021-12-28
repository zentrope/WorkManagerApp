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

    /// Initialize the data store, if necessary, with default data.
    func setup() async {
        do {
            try await insert(status: Status(id: 1, name: "Open"))
            try await insert(status: Status(id: 2, name: "Completed"))
            try await insert(status: Status(id: 3, name: "Archived"))
        } catch (let error) {
            fatalError("Unable to init status: \(error)")
        }
    }

    /// Create a new status.
    func insert(status: Status) async throws {
        logger.debug("Upserting \(status)")
        try await updateContext.perform(schedule: .enqueued) {
            let statusMO = StatusMO(context: updateContext)
            statusMO.id = Int16(status.id)
            statusMO.name = status.name
            try updateContext.save()
        }
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
}


//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for _ in 0..<10 {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()

//    init(inMemory: Bool = false) {
//        container = NSPersistentCloudKitContainer(name: "Fiddler")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.viewContext.automaticallyMergesChangesFromParent = true
//        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // added
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                /*
//                Typical reasons for an error here include:
//                * The parent directory does not exist, cannot be created, or disallows writing.
//                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                * The device is out of space.
//                * The store could not be migrated to the current model version.
//                Check the error message to determine what the actual problem was.
//                */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        self.updateContext = container.newBackgroundContext()
//
//    }

