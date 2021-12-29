//
//  ContentView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @State private var showMakeProjectView = false

    var body: some View {
        NavigationView {
            SidebarView()
            EmptySelectionView(systemName: "folder", message: "No folder selected")
            ProjectDetailView()
        }
        .navigationTitle("Tiny Project Manager")
    }
}
