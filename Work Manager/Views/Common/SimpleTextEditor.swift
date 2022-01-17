//
//  SimpleTextEditor.swift
//  Work Manager
//
//  Created by Keith Irwin on 1/16/22.
//

import Combine
import SwiftUI
import OSLog

fileprivate let log = Logger("SimpleTextEditor")

struct SimpleTextEditor: View {

    @Binding var text: String

    var body: some View {
        TextEditor(text: $text)
            .font(.body.monospaced())
            .padding()
    }
}
