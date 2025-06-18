//
//  StepBar.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

import SwiftUI

struct StepBar: View {
    var currentStep: Int = 1 // aktif di step ke-1
    
    let totalSteps = 4
    let steps: [String] = ["Take Picture", "Pick Color", "Add Data", "Analyze Data"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: 0) {
                    VStack {
                        StepCircle(number: index + 1, isActive: index == currentStep - 1, isDone : index < currentStep - 1)
                        Text(step)
                            .font(.smallMedium)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 50)
                    }

                    
                    if index != totalSteps - 1 {
                        Rectangle()
                            .fill(.mughalGreen500)
                            .frame(width: 40, height: 1.25)
                            .padding(.top, 20)

                    }
                }
            }
        }
    }
}

struct StepCircle: View {
    let number: Int
    let isActive: Bool
    let isDone: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(isActive ? .mughalGreen500 : .clear)
                .frame(width: 32, height: 32)
                .overlay(
                    Circle()
                        .stroke(.mughalGreen500, lineWidth: 1.25)
                )

            Text("\(isDone ? "✓" : "\(number)")")
                .foregroundColor(isActive ? .white : .mughalGreen500)
                .fontWeight(.medium)
        }
        .frame(width: 40, height: 40) // spacing antar lingkaran
    }
}

#Preview {
    StepBar(currentStep: 2)
}

