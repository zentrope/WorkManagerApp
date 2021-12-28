//
//  ProjectContentView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectContentView: View {

    @State private var showMakeProjectView = false

    var body: some View {
        List {
            NavigationLink(destination: ProjectDetailView()) {
                ProjectListItem(name: "Learn SwiftUI")
            }
            NavigationLink(destination: ProjectDetailView()) {
                ProjectListItem(name: "Learn CoreData")
            }
            NavigationLink(destination: ProjectDetailView()) {
                ProjectListItem(name: "Learn CloudKit")
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

struct ProjectContentViewView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectContentView()
    }
}
