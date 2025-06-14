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
    
    let totalSteps = 3

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...totalSteps, id: \.self) { index in
                HStack(spacing: 0) {
                    StepCircle(number: index, isActive: index == currentStep, isDone : index < currentStep)
                    
                    if index != totalSteps {
                        Rectangle()
                            .fill(.mughalGreen500)
                            .frame(width: 40, height: 1.25)
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

