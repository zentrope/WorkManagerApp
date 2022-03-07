//
//  FlatTaskListView.swift
//  Work Manager
//
//  Created by Keith Irwin on 3/6/22.
//

import SwiftUI

struct FlatTaskListView: View {
    @StateObject private var state = FlatTaskListViewState()

    @State private var selectedTask: UUID?

    var body: some View {
        List(selection: $selectedTask) {
            ForEach(state.tasks, id: \.id) { task in
                HStack(alignment: .center) {
                    Image(systemName: task.isCompleted ? "circle.inset.filled" : "circle")
                        .foregroundColor(task.isCompleted ? .secondary : .orange)
                        .font(.title2)
                    Text(task.name)
                    Spacer()
                    Text(task.project)
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .frame(width: 200, alignment: .leading)

                    Text(task.folder)
                        .font(.callout)
                        .frame(width: 85, alignment: .leading)
                        .foregroundColor(.secondary)
                }
                .tag(task.id)
                .opacity(task.isCompleted ? 0.5 : 1)
                .padding(.vertical, 1)
                .lineLimit(1)
                .contextMenu {
                    Button("Edit") {}
                    Button("Mark completed") {}
                }
            }
        } // end list
        .listStyle(.inset(alternatesRowBackgrounds: true))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
        .toolbar {
            ToolbarItem {
                ProjectPicker(projects: state.projects) { uuid in
                    state.setFilter(projectId: uuid)
                }
            }
        }
    }

}

struct ProjectPicker: View {

    var projects: [FlatTaskListViewState.Project]
    var onSelect: (UUID?) -> Void

    @State private var selection = ProjectPicker.selectAll
    @State private var isAll = true

    private var completed: [FlatTaskListViewState.Project] {
        projects.filter { $0.isCompleted }.sorted(by: {$0.name < $1.name })
    }

    private var available: [FlatTaskListViewState.Project] {
        projects.filter { !$0.isCompleted }.sorted(by: {$0.name < $1.name })
    }

    var body: some View {
        Menu {
            Toggle("All", isOn: $isAll)
            Picker("Available", selection: $selection) {
                ForEach(available, id: \.id) { project in
                    Text(project.name).tag(project.id)
                }
            }
            .pickerStyle(.inline)
            Picker("Completed", selection: $selection) {
                ForEach(completed, id: \.id) { project in
                    Text(project.name).tag(project.id)
                }
            }
            .pickerStyle(.inline)
        } label: {
            Image(systemName: "list.bullet.rectangle")
        }
        .onChange(of: isAll) { userWantsNoProjectFilter in
            if userWantsNoProjectFilter {
                selection = ProjectPicker.selectAll
            }
        }
        .onChange(of: selection) { newSelection in
            isAll = false
            onSelect(newSelection == ProjectPicker.selectAll ? nil : newSelection)
        }
    }

    private static let selectAll = UUID()
}

//
//struct FlatTaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlatTaskListView()
//    }
//}
