//
//  CoreDataUtils.swift
//  Work Manager
//
//  Created by Keith Irwin on 1/19/22.
//

import CoreData
import OSLog

fileprivate let log = Logger("CoreDataUtils")

enum CoreDataUtils {

    /// Given a CoreData object change notification and a projectId, figure out if the project itself or any of its associated tasks have changed.
    static func changed(msg: Notification, projectId: UUID) -> Bool {
        // The reason for this method is that we want to update a project view when something about the project changes, but we can't just rely on "an object changed" due to CloudKit integration, which (potentially) sends lots of updates we don't need to know about. This is kind of an NSFetchedResultsController for a single project and the tasks associated with it.
        guard let userInfo = msg.userInfo else { return false }
        return checkProject(info: userInfo, keys: [NSRefreshedObjectsKey, NSUpdatedObjectsKey], projectId: projectId)
    }

    private static func checkProject(info: [AnyHashable: Any], keys: [String], projectId: UUID) -> Bool {
        for key in keys {
            guard let items = info[key] as? Set<AnyHashable> else { continue }
            for item in items {
                if let project = item as? ProjectMO, project.id == projectId {
                    log.debug("The project has been updated.")
                    return true
                }
                if let task = item as? TaskMO, task.project?.id == projectId {
                    log.debug("A task in the project has been updated.")
                    return true
                }
            }
        }
        return false
    }
}
