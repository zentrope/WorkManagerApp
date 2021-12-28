//
//  EmptySelectionView.swift
//  Fiddler
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
        .foregroundColor(Color(NSColor.tertiaryLabelColor))
        .padding()
    }
}

struct EmptySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySelectionView(systemName: "flame", message: "No Filter Selected")
    }
}
