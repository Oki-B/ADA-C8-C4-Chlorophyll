//
//  Instructions.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 18/06/25.
//

import Foundation

struct Instruction: Identifiable {
    let id = UUID()
    let description: String
    let image: String
}

enum Instructions {
    static let instructions: [Instruction] = [
        .init(description: "Place your plant where the lighting is good", image: "step1"),
        .init(description: "Enable location services", image: "step2"),
        .init(description: "Stay online while scanning", image: "step3"),
        .init(description: "Make sure your camera lens is clean", image: "step4")
    ]
}
