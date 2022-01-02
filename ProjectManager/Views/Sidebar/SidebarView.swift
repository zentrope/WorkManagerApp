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
                        NavigationLink(destination: ProjectContentView(folder: folder), tag: folder.name, selection: $state.selectedFolder) {
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
                            if folder.projects.count == 0 {
                                Button("Delete") {
                                    state.delete(folder: folder)
                                }
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
    }

    private func handleFolderSave() {
        if saveOk {
            let name = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
            if name.isEmpty {
                log.error("Cannot create a folder with a blank folder name.")
                return
            }
            state.save(folder: Folder(name: name))
        }
        newFolderName = ""
    }

    private func handleFolderUpdate() {
        defer { newFolderName = "" }
        guard let folder = folderToEdit else {
            log.error("Unable to retrieve the folder we're updating.")
            return
        }
        if saveOk {
            let name = newFolderName.trimmingCharacters(in: .whitespacesAndNewlines)
            if name.isEmpty {
                log.error("Cannot update to a blank folder name.")
                return
            }
            state.update(folder: folder, name: name)
        }
    }
}
