//
//  ProjectDetailViewState.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation
import OSLog

fileprivate let log = Logger("ProjectDetailViewState")

class ProjectDetailViewState: NSObject, ObservableObject {

    @Published var project: Project
    @Published var error: Error?
    @Published var hasError = false

    init(preview project: Project) {
        self.project = project
        super.init()
    }

    init(project: Project) {
        self.project = project
        super.init()
        NotificationCenter.default.addObserver(forName: .NSManagedObjectContextDidSave, object: nil, queue: .main) { [weak self] msg in
            self?.reload()
        }
    }

    private func reload() {
        Task {
            do {
                let mo = try await PersistenceController.shared.find(project: project.id)
                await set(project: Project(mo: mo))
            } catch (let error) {
                set(error: error)
            }
        }
    }

    @MainActor
    private func set(project: Project) {
        self.project = project
    }

    private func set(error: Error) {
        self.error = error
        self.hasError = true
    }
}
