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

            // HEADING
            VStack(alignment: .leading, spacing: 6) {

                // TITLE + ICON
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

                // Status + Folder
                HStack(alignment: .center, spacing: 50) {
                    StatusView()
                    Spacer()
                    Text(viewState.project.folder.name)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 3)
                .padding(.top, 4)
            }
            .padding([.horizontal, .top], 20)

            ScrollView {
                Divider()
                ForEach(viewState.project.todoTasks, id: \.id) { task in
                    TaskItemView(task: task) { task in
                        viewState.toggle(task: task)
                    }
                    .lineLimit(1)
                    .padding(.bottom, 1)
                    .padding(.horizontal, 20)
                    .contextMenu {
                        Button("Rename") {
                            
                        }
                    }
                    Divider()
                }
                ForEach(viewState.project.doneTasks, id: \.id) { task in
                    TaskItemView(task: task) { task in
                        viewState.toggle(task: task)
                    }
                    .lineLimit(1)
                    .padding(.bottom, 1)
                    .padding(.horizontal, 20)
                    .contextMenu {
                        Button("Rename") {

                        }
                    }
                    Divider()
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

    @ViewBuilder
    private func StatusView() -> some View {
        let done = Double(viewState.project.doneCount)
        let total = Double(viewState.project.tasks.count)

        let value: Double = (done == 0.0 || total == 0.0) ? 0.0 : (done == total) ? 1.0 : done / total
        HStack(alignment: .center, spacing: 5) {
            switch value {
                case 0.0:
                    Text("Not started")
                        .foregroundColor(.orange)
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                case 1.0:
                    Text("Completed")
                        .foregroundColor(.accentColor)
                        .opacity(0.7)
                        .frame(maxWidth: .infinity, alignment: .leading)
                default:
                    Group {
                        Text(String(viewState.project.doneCount))
                            .foregroundColor(.accentColor)
                        ProgressView(value: value, total: 1)
                        Text(String(viewState.project.todoCount))
                            .foregroundColor(.orange)
                    }
            }
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let tasks = [
            ProjectTask(name: "Empty the garbage.",                       completed: false),
            ProjectTask(name: "Walk the dog.",                            completed: false),
            ProjectTask(name: "Sweep the floor.",                         completed: true),
            ProjectTask(name: "Clean kitchen sink.",                      completed: false),
            ProjectTask(name: "Clean those filthy refrigerator shelves.", completed: false),
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
