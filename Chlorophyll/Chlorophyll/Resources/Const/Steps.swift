//
//  Steps.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 18/06/25.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let title: String
}

enum Steps {
    static let steps: [Step] = [
        .init(title: "Take Picture"),
        .init(title: "Pick Color"),
        .init(title: "Add Data"),
        .init(title: "Analyze Data")
    ]
}
