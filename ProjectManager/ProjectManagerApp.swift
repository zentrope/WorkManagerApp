//
//  ProjectManagerApp.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Rename to WorkManager
// TODO: Export entire data set?
// TODO: Figure out an export format.
// TODO: Revise to work with CloudKit.
// TODO: Add filters
// TODO: Rename projects
// TODO: Rename folders
// TODO: Rename tasks
// TODO: Allow task date override
// TODO: Toggle project as completed (regardless of completed tasks)
// TODO: Launch project in new window, toggle, kill main window, toggle is undone
// TODO: Open to last selected project?

@main
struct ProjectManagerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            SidebarCommands()
        }

        Settings {
            SettingsView()
        }
    }
}
