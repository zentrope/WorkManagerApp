//
//  ProjectListItem.swift
//  Fiddler
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct ProjectListItem: View {
    var name: String
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Image(systemName: "checkmark.circle")
                .foregroundColor(.mint)
            Text("13")
                .foregroundColor(.mint)
            Image(systemName: "circle")
                .foregroundColor(.yellow)
            Text("10")
                .foregroundColor(.yellow)
        }
        .padding(2)
    }
}

struct ProjectListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListItem(name: "Start Fiddler Project")
    }
}
