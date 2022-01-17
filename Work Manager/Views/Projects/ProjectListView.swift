//
//  ProjectListView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/5/22.
//

import SwiftUI

struct ProjectListView: View {

    @StateObject private var state = ProjectListViewState()

    var filter: SidebarItem

    @State private var showMakeProjectView = false
    @State private var showRenameProjectView = false
    @State private var newProjectName = ""
    @State private var newProjectFolder = UUID()
    @State private var saveProject = false
    @State private var projectToDelete: Project?
    @State private var projectToRename: Project?

    var body: some View {
        VStack {
            List {
                if !state.todos.isEmpty {
                    Section(header: Text("Available")) {
                        ForEach(state.todos, id: \.id) { project in
                            NavigationLink(destination: ProjectDetailView(project)) {
                                ProjectListItem(project: project)
                            }
                            .contextMenu { ContextMenu(project: project) }
                        }
                    }
                }

                if !state.dones.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(state.dones, id: \.id) { project in
                            NavigationLink(destination: ProjectDetailView(project)) {
                                ProjectDoneItem(project: project)
                            }
                            .contextMenu { ContextMenu(project: project) }
                        }
                    }
                }
            }
            .listStyle(.inset)
            .alert(item: $projectToDelete) { project in
                Alert(
                    title: Text(#"Delete "\#(project.name)"?"#),
                    message: Text("This cannot be undone"),
                    primaryButton: .destructive(Text("Delete")) {
                        state.delete(project: project.id)
                    },
                    secondaryButton: .cancel())
            }
        }
        .frame(minWidth: 300, idealWidth: 300)
        .navigationTitle("\(filter.name) — Work Manager")
        .navigationSubtitle("\(state.projects.count) projects")
        .onAppear { state.set(filter: filter) }
        .alert(state.error?.localizedDescription ?? "Error", isPresented: $state.hasError) {}

        // Make a new project
        .sheet(isPresented: $showMakeProjectView) {
            if saveProject {
                state.save(project: newProjectName, folder: newProjectFolder)
            }
        } content: {
            ProjectFormView(folders: state.folders, name: $newProjectName, folder: $newProjectFolder, commit: $saveProject)
        }

        // Rename a project
        .sheet(isPresented: $showRenameProjectView) {
            if saveProject, let id = projectToRename?.id  {
                state.rename(project: id, withNewName: newProjectName)
            }
        } content: {
            RenameStringView(title: "Rename project",
                             prompt: "Project:",
                             systemName: "square.and.pencil",
                             text: $newProjectName,
                             commit: $saveProject)
        }
        .toolbar {
            ToolbarItem {
                Button {
                    newProjectName = "New Project"
                    if filter.isFolder {
                        newProjectFolder = filter.id
                    } else if let id = state.folders.first?.id {
                        newProjectFolder = id
                    }
                    showMakeProjectView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .help("Create a new project")
            }
        }
    }

    @ViewBuilder
    func ContextMenu(project: Project) -> some View {
        Button("Rename") {
            newProjectName = project.name
            newProjectFolder = project.folder.id
            projectToRename = project
            showRenameProjectView.toggle()
        }
        Button("Delete") {
            projectToDelete = project
        }
    }
}


