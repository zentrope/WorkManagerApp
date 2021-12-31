//
//  ContentView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @EnvironmentObject private var appState: AppState
    
    @State private var showMakeProjectView = false

    var body: some View {
        NavigationView {
            SidebarView()
            EmptySelectionView(systemName: "folder", message: "No folder selected")
            EmptySelectionView(systemName: "folder", message: "No project selected")
        }
        .navigationSubtitle(title)
    }

    private var title: String {
        let folder = appState.selectedFolder?.name ?? (appState.selectedStatus?.rawValue ?? "")
        return "\(folder) Projects".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
