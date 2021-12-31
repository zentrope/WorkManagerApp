//
//  EmptySelectionView.swift
//  ProjectManager
//
//  Created by Keith Irwin on 12/26/21.
//

import SwiftUI

struct EmptySelectionView: View {
    var systemName: String
    var message: String
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemName)
                .font(.system(size: 72).weight(.thin))
            Text(message)
                .font(.title)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(Color(nsColor: .tertiaryLabelColor))
        .background(Color(nsColor: .textBackgroundColor))
//        .toolbar {
//            // When no project is selected, show an empty toolbar so that the content column's toolbar items don't slide all the way to the trailing edge of the application window.
//            ToolbarItemGroup { Spacer() }
//        }
    }
}

struct EmptySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySelectionView(systemName: "flame", message: "No Filter Selected")
    }
}
