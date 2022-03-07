//
//  Persistence.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import CoreData
import OSLog

fileprivate let log = Logger("PersistenceController")

// TODO: Spotlight Integration
// https://www.raywenderlich.com/26871651-set-up-core-spotlight-with-core-data-getting-started

struct PersistenceController {

    static let shared = PersistenceController()

    var container: NSPersistentCloudKitContainer

    init() {
        let container = NSPersistentCloudKitContainer(name: "Work-Manager")

        container.loadPersistentStores { storeDescription, error in
            container.viewContext.automaticallyMergesChangesFromParent = true
            container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.container = container
    }

    private func newContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }

    /// Create a new folder.
    func insert(folder: Folder) async throws {
        log.debug("Upserting \(folder)")
        let context = newContext()
        try await context.perform {
            let folderMO = FolderMO(context: context)
            folderMO.id = folder.id
            folderMO.name = folder.name
            try context.commit()
        }
    }

    /// Change folder name.
    func update(folder: UUID, name: String) async throws {
        let context = newContext()
        try await context.perform {
            let folderMO = try find(folder: folder, context: context)
            folderMO.name = name
            try context.commit()
        }
    }

    /// Change task name
    func update(task: ProjectTask, name: String) async throws {
        let context = newContext()
        try await context.perform {
            let taskMO = try find(task: task.id, context: context)
            taskMO.name = name
            try context.commit()
        }
    }

    func rename(project: UUID, withNewName: String) async throws {
        let context = newContext()
        try await context.perform {
            let projectMO = try find(project: project, context: context)
            projectMO.name = withNewName
            try context.commit()
        }
    }

    func update(project id: UUID, withNote note: NSAttributedString) async throws {
        let context = newContext()
        try await context.perform {
            let projectMO = try find(project: id, context: context)
            projectMO.notes = note
            try context.commit()
        }
    }

    /// Create a project
    func insert(project: Project) async throws {
        log.debug("Upserting \(project)")

        let context = newContext()
        try await context.perform(schedule: .enqueued) {
            let folderMO = try find(folder: project.folder.id, context: context)
            let projectMO = ProjectMO(context: context)
            projectMO.id = project.id
            projectMO.name = project.name
            projectMO.isCompleted = project.isCompleted
            projectMO.dateCompleted = project.dateCompleted
            projectMO.folder = folderMO
            try context.commit()
        }
    }

    func insert(projectNamed name: String, inFolder id: UUID) async throws {
        log.debug(#"creating project "\#(name)" in folder "\#(id)""#)
        let context = newContext()
        try await context.perform {
            let projectId = UUID()
            let folderMO = try find(folder: id, context: context)
            let projectMO = ProjectMO(context: context)
            projectMO.id = projectId
            projectMO.name = name
            projectMO.isCompleted = false
            projectMO.dateCompleted = nil
            projectMO.folder = folderMO
            try context.commit()
        }
    }

    func delete(folder id: UUID) async throws {
        let context = newContext()
        try await context.perform {
            let folderMO = try find(folder: id, context: context)
            if folderMO.projects?.count != 0 {
                throw DataError.FolderNotEmpty
            }
            context.delete(folderMO)
            try context.commit()
        }
    }

    func delete(project uuid: UUID) async throws {
        let context = newContext()
        try await context.perform {
            let projectMO = try find(project: uuid, context: context)
            context.delete(projectMO)
            try context.commit()
        }
    }

    func delete(task uuid: UUID) async throws {
        let context = newContext()
        try await context.perform {
            let taskMO = try find(task: uuid, context: context)
            context.delete(taskMO)
            try context.commit()
        }
    }

    /// Create a project task
    func add(task: ProjectTask, to project: Project) async throws {
        log.debug("Upserting \(task)")
        let context = newContext()
        try await context.perform {
            let projectMO = try find(project: project.id, context: context)
            let taskMO = TaskMO(context: context)
            taskMO.id = task.id
            taskMO.name = task.name
            taskMO.isCompleted = task.isCompleted
            taskMO.dateCompleted = task.dateCompleted
            taskMO.project = projectMO
            try context.commit()
        }
    }

    func toggle(task: ProjectTask) async throws {
        log.debug("Toggle \(task).")
        let context = newContext()
        try await context.perform {
            let taskMO = try find(task: task.id, context: context)
            taskMO.isCompleted.toggle()
            if taskMO.isCompleted {
                taskMO.dateCompleted = Date()
            } else {
                taskMO.dateCompleted = nil
            }
            try context.commit()
        }
    }

    func toggle(project: Project) async throws {
        let context = newContext()
        try await context.perform {
            let projectMO = try find(project: project.id, context: context)
            projectMO.isCompleted.toggle()
            projectMO.dateCompleted = projectMO.isCompleted ? Date() : nil
            try context.commit()
        }
    }

    // MARK: - Queries

    enum DataError: Error, LocalizedError {
        case FolderNotFound
        case ProjectNotFound
        case TaskNotFound
        case FolderNotEmpty

        var errorDescription: String? {
            switch self {
                case .FolderNotFound: return "Folder not found."
                case .ProjectNotFound: return "Project not found."
                case .TaskNotFound: return "Task not found."
                case .FolderNotEmpty: return "Cannot delete a folder with projects in it."
            }
        }
    }

    private func find(folder id: UUID, context: NSManagedObjectContext) throws -> FolderMO {
        let request = FolderMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        if let folder = try context.fetch(request).first {
            return folder
        }
        throw DataError.FolderNotFound
    }

    private func find(project id: UUID, context: NSManagedObjectContext) throws -> ProjectMO {
        let request = ProjectMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        if let project = try context.fetch(request).first {
            return project
        }
        throw DataError.ProjectNotFound
    }

    private func find(task id: UUID, context: NSManagedObjectContext) throws -> TaskMO {
        let request = TaskMO.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        if let projectTask = try context.fetch(request).first {
            return projectTask
        }
        throw DataError.TaskNotFound
    }

    func find(project id: UUID) async throws -> ProjectMO {
        try find(project: id, context: container.viewContext)
    }

    func allProjects() throws -> [ProjectMO] {
        guard let request = container.managedObjectModel.fetchRequestTemplate(forName: "AllProjects") else {
            throw QueryError.NoFetchRequest("AllProjects")
        }
        if let projects = try container.viewContext.fetch(request) as? [ProjectMO] {
            return projects
        }
        throw QueryError.FetchFailed
    }
}

extension PersistenceController {
    enum QueryError: Error, LocalizedError {
        case NoFetchRequest(String)
        case FetchFailed

        var errorDescription: String? {
            switch self {
                case .NoFetchRequest(let name):
                    return "No fetch request named '\(name)' was found."
                case .FetchFailed:
                    return "Unable to complete a fetch."
            }
        }
    }
}

extension NSManagedObjectContext {

    func commit() throws {
        if hasChanges {
            try save()
        }
    }
}
