//
//  ProjectDetailView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Show the whole project and manage its lifecyle from this spot.
// TODO: Look at ScratchPad app for NSTextView editor help.
// https://www.swiftdevjournal.com/disable-a-text-field-in-a-swiftui-list-until-tapping-edit-button/

struct ProjectDetailView: View {

    @StateObject private var viewState: ProjectDetailViewState

    // New Task
    @State private var showNewTaskForm = false
    @State private var taskName = ""
    @State private var doSaveTask = false

    init(_ project: Project) {
        self._viewState = StateObject(wrappedValue: ProjectDetailViewState(project: project))
    }

    init(preview: Project) {
        self._viewState = StateObject(wrappedValue: ProjectDetailViewState(preview: preview))
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 10) {

                    Text(viewState.project.name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.secondary)
                    Spacer()
                    Image(systemName: "folder")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
                .lineLimit(1)
                HStack(alignment: .center, spacing: 10) {
                    Text("\(viewState.project.tasks.count) items")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .italic()
                    Spacer()
                    Text(viewState.project.folder.name)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 3)
            }
            .padding([.horizontal, .top], 20)

            ScrollView {
                ForEach(viewState.project.tasks, id: \.id) { task in
                    TaskItemView(task: task)
                        .lineLimit(1)
                        .padding(.vertical, 2)
                        .padding(.leading, 20)
                }
            }
            .padding(.bottom, 10)
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400)
        .background(Color(nsColor: .controlBackgroundColor))
        .toolbar {
            ToolbarItemGroup {

                Spacer()

                Button {
                    showNewTaskForm.toggle()
                } label: {
                    Image(systemName: "text.badge.plus")
                }
                .help("Create a new task")
            }
        }
        .sheet(isPresented: $showNewTaskForm, onDismiss: saveTask) {
            NewTaskView(project: viewState.project.name, folder: viewState.project.folder.name, name: $taskName, ok: $doSaveTask)
        }
        .navigationTitle(viewState.project.name)
        .navigationSubtitle(viewState.project.folder.name)

        .alert("ProjectDetailView: \(viewState.error?.localizedDescription ?? "Error")", isPresented: $viewState.hasError) {
            Button("Ok", role: .cancel) { }
        }
    }

    private func saveTask() {
        defer { taskName = "" }
        guard doSaveTask else { return }
        let task = ProjectTask(name: taskName)
        viewState.save(task: task)
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tasks = [
            ProjectTask(name: "Empty the garbage."),
            ProjectTask(name: "Walk the dog."),
            ProjectTask(name: "Sweep the floor."),
            ProjectTask(name: "Scrub down the dishwasher door."),
            ProjectTask(name: "Empty the garbage."),
            ProjectTask(name: "Walk the dog."),
            ProjectTask(name: "Sweep the floor."),
            ProjectTask(name: "Scrub down the dishwasher door."),
            ProjectTask(name: "Empty the garbage."),
            ProjectTask(name: "Walk the dog."),
            ProjectTask(name: "Sweep the floor."),
            ProjectTask(name: "Scrub down the dishwasher door."),
            ProjectTask(name: "Empty the garbage."),
            ProjectTask(name: "Walk the dog."),
            ProjectTask(name: "Sweep the floor."),
            ProjectTask(name: "Scrub down the dishwasher door."),
        ]
        let folder = Folder(name: "Admin")
        let project = Project(
            name: "Test this view in a preview window",
            folder: folder, tasks: tasks
        )        
        ProjectDetailView(preview: project)
    }
}
