//
//  ProjectContentView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectContentView: View {

    var folder: Folder

    @StateObject private var state = ProjectContentViewState()

    // Confirm delete
    @State private var projectToDelete: Project?

    // New Project State
    @State private var showMakeProjectView = false
    @State private var newProjectName = "New Project"
    @State private var saveNewProject = false

    var body: some View {
        VStack {
            List {
                ForEach(folder.projects, id: \.id) { project in
                    NavigationLink(destination: ProjectDetailView(project), tag: project.name, selection: $state.selectedProject) {
                        ProjectListItem(project: project)
                    }
                    .contextMenu {
                        Button("Delete") {
                            projectToDelete = project
                        }
                    }
                }
            }
            .listStyle(.inset)
            .alert(item: $projectToDelete) { project in
                Alert(
                    title: Text(#"Delete "\#(project.name)" and all its tasks?"#),
                    message: Text("This cannot be undone"),
                    primaryButton: .destructive(Text("Delete")) {
                        state.delete(project: project)                        
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .frame(minWidth: 300, idealWidth: 300)
        .sheet(isPresented: $showMakeProjectView) {
            if saveNewProject {
                Task {
                    await state.saveProject(name: newProjectName, folder: folder)
                    newProjectName = "New Project"
                }
            } else {
                newProjectName = "New Project"
            }
        } content: {
            NewProjectView(name: $newProjectName, doSave: $saveNewProject, folderName: folder.name)
        }
        .alert("\(state.error?.localizedDescription ?? "Error")", isPresented: $state.hasError) {}
        .toolbar {
            ToolbarItem {
                Button {
                    showMakeProjectView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .help("Create a new project")
            }
        }
        .navigationSubtitle(folder.name)
        .presentedWindowStyle(.titleBar)
        .presentedWindowToolbarStyle(.unified(showsTitle: true))
    }
}
