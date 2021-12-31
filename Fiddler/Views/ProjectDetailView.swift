//
//  ProjectDetailView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// @TODO: Show the whole project. When clicking "new" project, create a new one with a default title, then render it in this view where you can save it. Buttons along the bottom. Fill in the title along the topic. No need for a "sheet" for this one.

// @TODO: Look at ScratchPad app for NSTextView editor help.

struct ProjectDetailView: View {

    @StateObject private var viewState: ProjectDetailViewState

    @State private var showNewTaskForm = false

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

                Divider()
            }

            ScrollView {
                ForEach(viewState.project.tasks, id: \.id) { task in
                    TaskItemView(task: task)
                        .lineLimit(1)
                        .padding(.vertical, 2)
                        .padding(.leading, 3)
                }
            }
            Spacer()
        }
        .padding()
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 500)
        .background(Color(nsColor: .controlBackgroundColor))
        .navigationTitle(viewState.project.name)

        // MARK: - Toolbar
        .toolbar {
            ToolbarItem { Spacer() }
            ToolbarItem {
                Button {
                    showNewTaskForm.toggle()
                } label: {
                    Image(systemName: "text.badge.plus")
                }
            }
        }

        // MARK: - New Task Sheet
        .sheet(isPresented: $showNewTaskForm) {

        } content: {
            NewTaskView(project: viewState.project)
        }
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
        //let viewState = ProjectDetailViewState(preview: testProject)
        ProjectDetailView(preview: project)
    }
}
