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

    @State private var showDeleteConfirm = false
    @State private var folderToDelete: Folder?

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
                                    folderToDelete = folder
                                    showDeleteConfirm.toggle()
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .alert(item: $folderToDelete) { deleteAlert(folder: $0) }
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

    private func deleteAlert(folder: Folder) -> Alert {
        Alert(
            title: Text("Delete '\(folder.name)'?"),
            message: Text("This cannot be undone."),
            primaryButton: .destructive(Text("Delete")) {
                state.delete(folder: folder)
            },
            secondaryButton: .cancel()
        )
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
