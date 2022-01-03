//
//  ProjectContentView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import OSLog

fileprivate let log = Logger("ProjectContentView")

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
        VStack(alignment: .leading) {
            List {

                HStack(alignment: .center) {
                    Text(folder.name)
                        .bold()
                    Spacer()
                    Image(systemName: "folder")
                }
                .foregroundColor(.accentColor)
                .font(.title2)
                .padding(.bottom, 0)

                if folder.todo.count > 0 {
                    Section(header: Text("Available")) {
                        ForEach(folder.todo, id: \.id) { project in
                            NavigationLink(destination: ProjectDetailView(project), tag: project.name, selection: $state.selectedTodo) {
                                ProjectListItem(project: project)
                            }
                            .contextMenu {
                                Button("Delete") {
                                    projectToDelete = project
                                }
                                Button("Mark completed") {
                                    state.toggle(project: project)
                                }
                            }
                        }
                    }
                }
                if folder.done.count > 0 {
                    Section(header: Text("Completed")) {
                        ForEach(folder.done, id: \.id) { project in
                            NavigationLink(destination: ProjectDetailView(project), tag: project.name, selection: $state.selectedDone) {
                                ProjectDoneItem(project: project)
                            }
                            .contextMenu {
                                Button("Delete") {
                                    projectToDelete = project
                                }
                                Button("Mark available") {
                                    state.toggle(project: project)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.inset)
            .alert(item: $projectToDelete) { project in
                Alert(
                    title:           Text(#"Delete "\#(project.name)" and all its tasks?"#),
                    message:         Text("This cannot be undone"),
                    primaryButton:   .destructive(Text("Delete")) { state.delete(project: project)  },
                    secondaryButton: .cancel())
            }
        }
        .frame(minWidth: 300, idealWidth: 300)
        .onChange(of: folder) { newFolder in
            // Hack to deal with two lists (done and todo) when a project moves from one list to the other.
            state.swapSelections()
        }
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
    }
}
