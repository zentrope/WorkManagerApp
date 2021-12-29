//
//  SidebarView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct SidebarView: View {

    @EnvironmentObject private var appState: AppState

    @State private var showNewFolderSheet = false

    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section(header: Text("Status")) {
                    ForEach(AppState.Status.allCases, id: \.self) { status in
                        NavigationLink(destination: ProjectContentView(), tag: status, selection: $appState.selectedStatus) {
                            Label(status.rawValue, systemImage: "folder")
                        }
                    }
                }

                Section(header: Text("Active Folders")) {
                    ForEach(appState.folders, id: \.id) { folder in
                        NavigationLink(destination: ProjectContentView(), tag: folder, selection: $appState.selectedFolder) {
                            Label(folder.name, systemImage: "tag")
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            Spacer()

            HStack {
                Spacer()
                Button {
                    showNewFolderSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderlessButtonStyle())
                .help("Add a new folder")
            }
            .padding(10)
        }
        .frame(minWidth: 185, idealWidth: 185, maxHeight: .infinity, alignment: .leading)
        .sheet(isPresented: $showNewFolderSheet) {
        } content: {
            NewFolderView()
        }
    }
}
