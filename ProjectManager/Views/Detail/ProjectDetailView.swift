//
//  ProjectDetailView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Look at ScratchPad app for NSTextView editor help.

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

        VStack(alignment: .leading, spacing: 0) {

            HStack(alignment: .center, spacing: 10) {

                VStack(alignment: .leading) {
                Text(viewState.project.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.secondary)
                    Text(viewState.project.folder.name)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .italic()
                }

                Spacer()
                ProjectStatusIcon(done: viewState.project.doneCount, total: viewState.project.tasks.count)
                    .foregroundColor(.accentColor)
                    .font(.largeTitle)
            }
            .lineLimit(1)

            .padding(.top, 14) // Match content column's title
            .padding([.horizontal, .bottom])

            if viewState.project.tasks.count != 0 {
                StatusView()
                    .padding(.vertical, 5)
                    .padding(.horizontal, 9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(4, antialiased: true)
                    .padding()
            }

            if viewState.project.tasks.count == 0 {
                EmptySelectionView(systemName: "sparkles", message: "No tasks have been added to this project")
            } else {
                ScrollView {

                    if viewState.project.todoCount > 0 {
                        Heading("Available")
                    }

                    ForEach(viewState.project.todoTasks, id: \.id) { task in
                        TaskItemView(task: task) { task in
                            viewState.toggle(task: task)
                        }
                        .lineLimit(1)
                        .padding(.bottom, 1)
                        .padding(.horizontal, 20)
                        .contextMenu {
                            Button("Rename") {}
                        }
                    }
                    .animation(.linear, value: viewState.project.todoTasks)

                    if viewState.project.doneCount > 0 {
                        Heading("Completed")
                    }

                    ForEach(viewState.project.doneTasks, id: \.id) { task in
                        TaskItemView(task: task) { task in
                            viewState.toggle(task: task)
                        }
                        .lineLimit(1)
                        .padding(.bottom, 1)
                        .padding(.horizontal, 20)
                        .contextMenu {
                            Button("Rename") {}
                        }
                    }
                    .animation(.linear, value: viewState.project.doneTasks)
                }
            }
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400)
        .background(Color(nsColor: .controlBackgroundColor))
        .toolbar {
            ToolbarItemGroup {

                Spacer()

                Button {
                    showNewTaskForm.toggle()
                } label: {
                    Image(systemName: "plus")
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

    @ViewBuilder
    private func StatusView() -> some View {
        let done = Double(viewState.project.doneCount)
        let total = Double(viewState.project.tasks.count)

        let value: Double = (done == 0.0 || total == 0.0) ? 0.0 : (done == total) ? 1.0 : done / total
        HStack(alignment: .center, spacing: 5) {
            Text(String(viewState.project.doneCount))
                .foregroundColor(.secondary)
            ProgressView(value: value, total: 1)
            Text(String(viewState.project.todoCount))
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private func Heading(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .padding(.vertical, 5)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.1))
            .cornerRadius(4, antialiased: true)
            .padding()
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tasks = [
            ProjectTask(name: "Empty the garbage.",                       completed: false),
            ProjectTask(name: "Walk the dog.",                            completed: false),
            ProjectTask(name: "Sweep the floor.",                         completed: false),
            ProjectTask(name: "Clean kitchen sink.",                      completed: false),
            ProjectTask(name: "Clean those filthy refrigerator shelves.", completed: true),
            ProjectTask(name: "Scrub down the dishwasher door.",          completed: false),
        ].sorted(by: { $0.name < $1.name })
        let folder = Folder(name: "Admin")
        let project = Project(
            name: "Test this view in a preview window",
            folder: folder, tasks: tasks
        )
        ProjectDetailView(preview: project)
    }
}
