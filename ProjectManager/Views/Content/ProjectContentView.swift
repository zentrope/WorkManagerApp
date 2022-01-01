//
//  ProjectContentView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectContentView: View {

    var folder: Folder
    @State private var showMakeProjectView = false
    @State private var selectedProject: String?

    var body: some View {
        VStack {
            List {
                ForEach(folder.projects, id: \.id) { project in
                    NavigationLink(destination: ProjectDetailView(project), tag: project.name, selection: $selectedProject) {
                        ProjectListItem(project: project)
                    }
                }
            }
            .listStyle(.inset)
        }
        .frame(minWidth: 300, idealWidth: 300)
        .toolbar {
            // TODO: Move content toolbar item to detail view
            ToolbarItem {
                Button {
                    showMakeProjectView.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showMakeProjectView, onDismiss: {}, content: { NewProjectView() })
        .navigationTitle("ProjectManager")
        .navigationSubtitle(selectedProject ?? folder.name)
        .presentedWindowStyle(.titleBar)
        .presentedWindowToolbarStyle(.unified(showsTitle: true))
    }
}
