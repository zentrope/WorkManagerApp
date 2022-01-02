//
//  ProjectManagerApp.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

@main
struct ProjectManagerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
        .commands {
            SidebarCommands()
        }

        Settings {
            SettingsView()
        }
    }
}
