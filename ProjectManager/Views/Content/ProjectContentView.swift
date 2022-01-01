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
                }
            }
            .listStyle(.inset)
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
        .alert(state.error?.localizedDescription ?? "Error", isPresented: $state.hasError) {
            Button("Ok", role: .cancel) { }
        }
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
