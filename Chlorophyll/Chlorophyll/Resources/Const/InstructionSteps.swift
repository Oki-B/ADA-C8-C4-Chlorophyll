//
//  InstructionSteps.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import Foundation

struct InstructionStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

enum InstructionSteps {
    static let steps: [InstructionStep] = [
        .init(title: "Take a Picture", description: "Take a picture of the soil."),
        .init(title: "Confirm Color Input", description: "Make sure the inputed color is match with soil"),
        .init(title: "Answer Additional Question", description: "Let us know more about your soil based on place condition"),
        .init(title: "Submit All Input", description: "Get final result based on your input"),
    ]
}
