//
//  InstructionView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 15/06/25.
//

import SwiftUI

struct InstructionView: View {

    let steps = InstructionSteps.steps

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Tutorial")
                    .font(.h1)
                Text("Get knowing your soil plant with just four simple steps.")
                    .font(.h3)
                    .foregroundStyle(.midGreenYellow700)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
            }

            Spacer()
            Spacer()

            ForEach(Array(steps.enumerated()), id: \.element.id) {
                index,
                step in
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("\(index + 1)")
                            .font(.h2)
                            .foregroundStyle(.mughalGreen500)
                            .frame(width: 50, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.mughalGreen500, lineWidth: 4)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        if index + 1 < steps.count {
                            Rectangle()
                                .frame(width: 2, height: 42)
                                .foregroundColor(.mughalGreen500)
                        }
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(step.title)")
                            .font(.h4)
                            .foregroundStyle(.mughalGreen500)

                        Text("\(step.description)")
                            .font(.baseMedium)
                            .foregroundStyle(.darkCharcoal500)
                    }
                    .frame(maxWidth: 225, alignment: .leading)

                }
            }

            Spacer()
            Spacer()

            ActionButton(
                title: .begin,
                action: {
                    // write action code here
                }
            )
            
        }
        .padding()
    }
}

#Preview {
    InstructionView()
}
