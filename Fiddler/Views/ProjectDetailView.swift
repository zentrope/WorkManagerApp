//
//  ProjectDetailView.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

// @TODO: Show the whole project. When clicking "new" project, create a new one with a default title, then render it in this view where you can save it. Buttons along the bottom. Fill in the title along the topic. No need for a "sheet" for this one.

struct ProjectDetailView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Not Implemented")
                .font(.largeTitle)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }

        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 500)
        .background(Color(nsColor: .textBackgroundColor))
        .navigationTitle("Not Implemented Doc")
        .toolbar {
            ToolbarItem { Spacer() }
            ToolbarItem {
                Button {
                    print("DV")
                } label: {
                    Image(systemName: "text.badge.plus")
                }
            }
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectDetailView()
    }
}
