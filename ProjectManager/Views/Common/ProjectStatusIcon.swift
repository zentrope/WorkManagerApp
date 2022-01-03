//
//  ProjectStatusIcon.swift
//  ProjectManager
//
//  Created by Keith Irwin on 1/1/22.
//

import SwiftUI

// TODO: Change to pie-chart crescent showing completeness
// Or create a box with a percentage fill (or two boxes), then apply a circle clip.
struct ProjectStatusIcon: View {
    var done: Int
    var total: Int
    var body: some View {
        switch done {
            case 0:
                Image(systemName: "sparkles")
            case total:
                Image(systemName: "circle.inset.filled")
            default:
                Image(systemName: "circle.bottomhalf.filled")
        }
    }
}

struct ProjectStatusIcon_Previews: PreviewProvider {
    static var previews: some View {
        ProjectStatusIcon(done: 2, total: 10)
    }
}
