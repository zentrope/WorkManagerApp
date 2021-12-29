//
//  ProjectContentView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectContentView: View {

    @EnvironmentObject private var appState: AppState

    @State private var showMakeProjectView = false

    var body: some View {
        List {
            ForEach(appState.projects, id: \.id) { project in
                NavigationLink(destination: ProjectDetailView(), tag: project, selection: $appState.selectedProject) {
                    ProjectListItem(project: project)
                }
            }
        }
        .listStyle(.inset)
        .frame(minWidth: 300, idealWidth: 300)
        .navigationTitle("Projects")
        .toolbar {
            Button {
                showMakeProjectView.toggle()
            } label: {
                Image(systemName: "folder.badge.plus")
            }
        }
        .sheet(isPresented: $showMakeProjectView) {
            print("Dismissed")
        } content: {
            NewProjectView()
        }
    }
}
