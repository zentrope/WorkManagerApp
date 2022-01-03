//
//  ProjectDetailView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// TODO: Look at ScratchPad app for NSTextView editor help.

struct ProjectDetailView: View {

    @StateObject private var state: ProjectDetailViewState

    // Task maintenance
    @State private var showNewTaskForm = false
    @State private var showEditTaskForm = false
    @State private var taskName = ""
    @State private var doSaveTask = false
    @State private var taskToEdit: ProjectTask?

    init(_ project: Project) {
        self._state = StateObject(wrappedValue: ProjectDetailViewState(project: project))
    }

    init(preview: Project) {
        self._state = StateObject(wrappedValue: ProjectDetailViewState(preview: preview))
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack(alignment: .top, spacing: 10) {

                Text(state.project.name)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.accentColor)
                    .foregroundColor(state.project.isCompleted ? .secondary : .accentColor)

                Spacer()

                Image(systemName: state.project.isCompleted ? "checkmark.circle" : "circle")
                    .font(.title2)
                    .foregroundColor(state.project.isCompleted ? .secondary : .orange)
                    .onTapGesture {
                        Task {
                            state.toggle(project: state.project)
                        }
                    }
                    .onHover { inside in
                        if inside {
                            NSCursor.pointingHand.push()
                        } else {
                            NSCursor.pop()
                        }
                    }
            }
            .lineLimit(1)
            .padding(.top, 14) // Match content column's title
            .padding([.horizontal])

            Text(state.project.folder.name)
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if !state.project.isCompleted && state.project.tasks.count != 0 {
                StatusView()
                    .padding(.vertical, 5)
                    .padding(.horizontal, 9)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(4, antialiased: true)
                    .padding()
            }

            if state.project.tasks.count == 0 {
                EmptySelectionView(systemName: "sparkles", message: "No tasks have been added to this project")
            }

            if state.project.tasks.count > 0 {
                ScrollView {

                    Heading("Unfinished", renderIf: state.project.todoCount > 0 && state.project.isCompleted)
                    Heading("Available", renderIf: state.project.todoCount > 0 && !state.project.isCompleted)

                    ForEach(state.project.todoTasks, id: \.id) { task in
                        TaskItemView(project: state.project, task: task) { task in
                            state.toggle(task: task)
                        }
                        .lineLimit(1)
                        .padding(.bottom, 1)
                        .padding(.horizontal, 20)
                        .contextMenu {
                            Button("Rename", action: { handleRename(task) })
                        }
                    }

                    Heading("Completed", renderIf: state.project.doneCount > 0)

                    ForEach(state.project.doneTasks, id: \.id) { task in
                        TaskItemView(project: state.project, task: task) { task in
                            state.toggle(task: task)
                        }
                        .lineLimit(1)
                        .padding(.bottom, 1)
                        .padding(.horizontal, 20)
                        .contextMenu {
                            Button("Rename", action: { handleRename(task) })
                        }
                    }
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
            TaskDataForm(mode: .create, project: state.project.name, folder: state.project.folder.name, name: $taskName, ok: $doSaveTask)
        }
        .sheet(isPresented: $showEditTaskForm, onDismiss: editTask) {
            TaskDataForm(mode: .update, project: state.project.name, folder: state.project.folder.name, name: $taskName, ok: $doSaveTask)
        }
        .navigationTitle(state.project.name)
        .navigationSubtitle(state.project.folder.name)

        .alert("ProjectDetailView: \(state.error?.localizedDescription ?? "Error")", isPresented: $state.hasError) {
            Button("Ok", role: .cancel) { }
        }
    }

    private func handleRename(_ task: ProjectTask) {
        taskToEdit = task
        taskName = task.name
        showEditTaskForm.toggle()
    }

    private func saveTask() {
        defer { taskName = "" }
        guard doSaveTask else { return }
        let name = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return
        }
        let task = ProjectTask(name: name)
        state.save(task: task)
    }

    private func editTask() {
        defer { taskName = "" }
        guard doSaveTask else { return }
        guard let todo = taskToEdit else { return }
        let name = taskName.trimmingCharacters(in: .whitespacesAndNewlines)
        if name.isEmpty {
            return
        }
        state.rename(task: todo, name: name)
    }

    @ViewBuilder
    private func StatusView() -> some View {
        let done = Double(state.project.doneCount)
        let total = Double(state.project.tasks.count)

        let value: Double = (done == 0.0 || total == 0.0) ? 0.0 : (done == total) ? 1.0 : done / total
        HStack(alignment: .center, spacing: 5) {
            Text(String(state.project.doneCount))
                .foregroundColor(.secondary)
            ProgressView(value: value, total: 1)
            Text(String(state.project.todoCount))
                .foregroundColor(.secondary)
        }
    }

    @ViewBuilder
    private func Heading(_ text: String, renderIf render: Bool) -> some View {
        if render {
            Text(text)
                .font(.body)
                .padding(.vertical, 5)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.gray.opacity(0.1))
                .cornerRadius(4, antialiased: true)
                .padding()
        } else {
            EmptyView()
        }
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
