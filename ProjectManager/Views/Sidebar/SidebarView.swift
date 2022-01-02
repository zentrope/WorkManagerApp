//
//  SidebarView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import OSLog

fileprivate let log = Logger("SidebarView")

struct SidebarView: View {

    @StateObject private var state = SidebarViewState()

    @State private var selectedFolder: String?
    @State private var showEditFolderSheet = false
    @State private var folderToEdit: Folder?
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
                        .contextMenu {
                            Button("Rename") {
                                newFolderName = folder.name
                                folderToEdit = folder
                                saveOk = false
                                showEditFolderSheet.toggle()
                            }
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
            FolderForm(mode: .create, name: $newFolderName, ok: $saveOk)
        }
        .sheet(isPresented: $showEditFolderSheet, onDismiss: handleFolderUpdate) {
            FolderForm(mode: .update, name: $newFolderName, ok: $saveOk)
        }
        .alert("\(state.error?.localizedDescription ?? "Error!")", isPresented: $state.hasError) {}
        .onAppear { selectedFolder = state.folders.first?.name }
    }

    private func handleFolderSave() {
        if saveOk {
            state.save(folder: Folder(name: newFolderName))
            selectedFolder = newFolderName
        }
        newFolderName = ""
    }

    private func handleFolderUpdate() {
        guard let folder = folderToEdit else {
            log.debug("Unable to retrieve the folder we're updating.")
            return
        }
        if saveOk {
            state.update(folder: folder, name: newFolderName)
        }
        newFolderName = ""
    }
}
