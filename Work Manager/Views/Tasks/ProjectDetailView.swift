//
//  ProjectDetailView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI
import OSLog

fileprivate let log = Logger("ProjectDetailView")

// TODO: Look at ScratchPad app for NSTextView editor help.

struct ProjectDetailView: View {

    @StateObject private var state: ProjectDetailViewState

    // Task maintenance
    @State private var showNewTaskForm = false
    @State private var showEditTaskForm = false

    @State private var taskName = ""
    @State private var doSaveTask = false
    @State private var taskToEdit: ProjectTask?
    @State private var taskToDelete: ProjectTask?

    @State private var showProjectNotes = false

    init(_ project: Project) {
        self._state = StateObject(wrappedValue: ProjectDetailViewState(project: project))
    }

    init(preview: Project) {
        self._state = StateObject(wrappedValue: ProjectDetailViewState(preview: preview))
    }

    var body: some View {

        VStack {
            HSplitView {
                List {
                    LocationView()
                        .padding([.top])
                        .padding(.bottom, 2)

                    TitleView()

                    StatusView(render: !state.project.isCompleted && state.project.tasks.count != 0)
                        .padding(.top)

                    if !state.project.todoTasks.isEmpty {
                        Section(header: Text("Available")) {
                            ForEach(state.project.todoTasks, id: \.id) { task in
                                TaskItemView(project: state.project, task: task) { task in
                                    state.toggle(task: task)
                                }
                                .padding(.horizontal)
                                .lineLimit(1)
                                .padding(.bottom, 2)
                                .contextMenu { ContextMenu(task: task) }
                            }
                        }
                    }

                    if !state.project.doneTasks.isEmpty {
                        Section(header: Text("Completed")) {
                            ForEach(state.project.doneTasks, id: \.id) { task in
                                TaskItemView(project: state.project, task: task) { task in
                                    state.toggle(task: task)
                                }
                                .lineLimit(1)
                                .padding(.horizontal)
                                .padding(.bottom, 2)
                                .contextMenu { ContextMenu(task: task) }
                            }
                        }
                    }
                }
                .listStyle(.inset)
                .frame(minWidth: 450)
                .alert(item: $taskToDelete) { task in
                    Alert(title: Text("Delete '\(task.name)'?"), message: Text("This cannot be undone."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete Task")) {
                        state.delete(task: task)
                    })
                }

                if showProjectNotes {
                    VStack {
                        TextEditor(text: $state.notes)
                            .disableAutocorrection(false)
                            .font(.body.monospaced())
                            .padding()
                            .onDisappear {
                                state.update(note: state.notes)
                            }
                    }
                    .background(Color(nsColor: .textBackgroundColor))
                    .frame(minWidth: 400, maxWidth: .infinity, alignment: .leading)
                    //.layoutPriority(1)
                }
            }
        }
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
        .toolbar {
            ToolbarItemGroup {

                Spacer()

                Button {
                    showNewTaskForm.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .keyboardShortcut("n", modifiers: [.control, .command])
                .help("Create a new task")
            }

            ToolbarItem {
                Button {
                    showProjectNotes.toggle()
                } label: {
                    Image(systemName: "sidebar.trailing")
                }
                .help("Toggle project notes editor")
            }
        }
        .sheet(isPresented: $showNewTaskForm, onDismiss: saveTask) {
            TaskDataForm(isEdit: false, name: $taskName, ok: $doSaveTask)
        }
        .sheet(isPresented: $showEditTaskForm, onDismiss: editTask) {
            TaskDataForm(isEdit: true, name: $taskName, ok: $doSaveTask)
        }
        .navigationTitle("\(state.project.name) — Work Manager")
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

}

// MARK: - Supplemental Views

extension ProjectDetailView {

    @ViewBuilder
    private func ContextMenu(task: ProjectTask) -> some View {
        Button("Rename") {
            handleRename(task)
        }
        Button("Delete") {
            taskToDelete = task
        }
        Button("Copy") {
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(task.name, forType: .string)
        }
    }

    @ViewBuilder
    private func LocationView() -> some View {
        HStack(alignment: .center, spacing: 6) {
            Image(systemName: "folder")
            Text(state.project.folder.name)
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
        .font(.callout)
        .foregroundColor(.secondary)
    }

    @ViewBuilder
    private func TitleView() -> some View {
        Text(state.project.name)
            .font(.title2)
            .bold()
            .foregroundColor(.accentColor)
            .foregroundColor(state.project.isCompleted ? .secondary : .accentColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(1)
    }

    @ViewBuilder
    private func StatusView(render: Bool) -> some View {
        if render {
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
            .padding(.vertical, 5)
            .padding(.horizontal, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.gray.opacity(0.1))
            .cornerRadius(4, antialiased: true)

        } else {
            EmptyView()
        }
    }
}

// MARK: - Preview Provider

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tasks = [
            ProjectTask(name: "Empty the garbage.",                       completed: true),
            ProjectTask(name: "Walk the dog.",                            completed: false),
            ProjectTask(name: "Sweep the floor.",                         completed: true),
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
