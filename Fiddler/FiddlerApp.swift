//
//  FiddlerApp.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

@main
struct FiddlerApp: App {

    private let appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .frame(minWidth: 1024, minHeight: 600)
        }

        //.windowStyle(TitleBarWindowStyle())
        //.windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: false))
        .commands {
            SidebarCommands()
        }

        Settings {
            SettingsView()
        }
    }
}
