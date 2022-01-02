//
//  SidebarView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Add alert / error handling

struct SidebarView: View {

    @StateObject private var state = SidebarViewState()

    @State private var selectedFolder: String?

    @State private var showNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var saveOk = false

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Folders")) {
                    ForEach(state.folders, id: \.id) { folder in
                        NavigationLink(destination: ProjectContentView(folder: folder), tag: folder.name, selection: $selectedFolder) {
                            Label(folder.name, systemImage: "folder")
                                .badge(folder.projects.count)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            Spacer()
            HStack(alignment: .center) {
                Button {
                    showNewFolderSheet.toggle()
                } label: {
                    Label("New Folder", systemImage: "plus.circle")
                }
                .buttonStyle(.plain)
                .help("Add a new folder")
                Spacer()
            }
            .padding(10)
        }
        .frame(minWidth: 185, idealWidth: 185, maxHeight: .infinity, alignment: .leading)
        .sheet(isPresented: $showNewFolderSheet, onDismiss: handleFolderSave) {
            NewFolderView(name: $newFolderName, ok: $saveOk)
        }
        .onAppear { selectedFolder = state.folders.first?.name }
    }

    private func handleFolderSave() {
        if saveOk {
            state.save(folder: Folder(name: newFolderName))
            selectedFolder = newFolderName
        }
        newFolderName = ""
    }
}
