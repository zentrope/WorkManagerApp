//
//  ProjectManagerApp.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Make task area a text view but force every line to be a checkbox

// TODO: Rename to WorkManager
// TODO: Export entire data set?
// TODO: Figure out an export format.
// TODO: Revise to work with CloudKit.

// TODO: Add filters (all, 2021, 2022)
// TODO: Move project to new folder (drag drop?)
// TODO: Allow task date override

// TODO: Fix: Launch project in new window, toggle, kill main window, toggle is undone

// TODO: Open to last selected project?  @AppStorage
// TODO: Open to last selected folder?  @AppStorage
// TODO: Create unique default task names (New Project 1, New Project 2, etc).

// LINK: https://www.swiftdevjournal.com/disable-a-text-field-in-a-swiftui-list-until-tapping-edit-button/

@main
struct Work_ManagerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, idealWidth: 980, minHeight: 400, idealHeight: 600)
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
