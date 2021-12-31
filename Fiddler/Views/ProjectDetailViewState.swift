//
//  ProjectDetailViewState.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/30/21.
//

import Foundation

class ProjectDetailViewState: NSObject, ObservableObject {

    @Published var project: Project

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
            let mo = try await PersistenceController.shared.find(project: project.id)
            await set(project: Project(mo: mo))
        }
    }

    @MainActor
    private func set(project: Project) {
        self.project = project
    }
}
