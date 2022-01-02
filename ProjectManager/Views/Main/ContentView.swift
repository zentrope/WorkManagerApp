//
//  ContentView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        NavigationView {
            SidebarView()
            EmptySelectionView(systemName: "folder", message: "No folder selected")
            EmptySelectionView(systemName: "folder", message: "No project selected")
        }
    }
}
