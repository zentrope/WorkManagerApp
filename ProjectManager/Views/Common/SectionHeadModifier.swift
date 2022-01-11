//
//  SectionHeadModifier.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/5/22.
//

import SwiftUI

struct SectionHead: View {
    var text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.system(size: 11).weight(.semibold))
            .foregroundColor(Color(nsColor: .secondaryLabelColor))
    }
}

//fileprivate struct SectionHeadModifier: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .font(.system(size: 11).weight(.semibold))
//            .foregroundColor(Color(nsColor: .secondaryLabelColor))
//    }
//}
//
//extension View {
//    func sectionHeader() -> some View {
//        modifier(SectionHeadModifier())
//    }
//}
