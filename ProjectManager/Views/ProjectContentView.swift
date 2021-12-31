//
//  ProjectContentView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectContentView: View {

    @EnvironmentObject private var appState: AppState

    @State private var showMakeProjectView = false

    var body: some View {
        VStack {
            List {
                ForEach(appState.projects, id: \.id) { project in
                    NavigationLink(destination: ProjectDetailView(project)) {
                        ProjectListItem(project: project)
                    }
                }
            }
            .listStyle(.inset)
        }
        .frame(minWidth: 300, idealWidth: 300)
        .toolbar {
            ToolbarItem {
                Button {
                    showMakeProjectView.toggle()
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showMakeProjectView, onDismiss: {}, content: { NewProjectView() })
        .presentedWindowStyle(.titleBar)
        .presentedWindowToolbarStyle(.unified(showsTitle: true))
    }
}
