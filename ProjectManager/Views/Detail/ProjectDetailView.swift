//
//  ProjectDetailView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// @TODO: Show the whole project and manage its lifecyle from this spot.
// When clicking "new" project, create a new one with a default title, then render it in this view where you can save it. Buttons along the bottom. Fill in the title along the topic. No need for a "sheet" for this one.

// @TODO: Look at ScratchPad app for NSTextView editor help.

// https://www.swiftdevjournal.com/disable-a-text-field-in-a-swiftui-list-until-tapping-edit-button/


struct ProjectDetailView: View {

    @StateObject private var viewState: ProjectDetailViewState

    @State private var showNewTaskForm = false

    init(_ project: Project) {
        // There's controversy about whether or not this is a legit thing to do. Here's what I'm thinking: Although this initializer might be called multiple times to render changes, the StateObject will only be initialized the first time, and never again until this view disappears from the view hierarchy. Therefore, we can initialize it in this way. When the user double-clicks the row in the content column, this object will spawn a new window, which requires a new viewState so that it can register changes independently of the main window. Anyway, this seems to be working. The reason I don't set the viewState property from the main window is that if we close the main window, the spawned window's data goes away.
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
        .sheet(isPresented: $showNewTaskForm, onDismiss: {}) {
            NewTaskView(project: viewState.project)
        }
        .navigationTitle(viewState.project.name)
        .navigationSubtitle(viewState.project.folder.name)

        .alert("ProjectDetailView: \(viewState.error?.localizedDescription ?? "Error")", isPresented: $viewState.hasError) {
            Button("Ok", role: .cancel) { }
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
        ProjectDetailView(preview: project)
    }
}
