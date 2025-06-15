//
//  ConfirmColorView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI

struct ConfirmColorView: View {
    @StateObject private var viewModel = ConfirmColorViewModel()

    var body: some View {
        VStack {
            StepBar(currentStep: 2)

            Spacer()

            Text(
                "Use the photo to pick soil color that most closely matches your sample."
            )
            .font(.h3)
            .foregroundStyle(.darkCharcoal700)
            .multilineTextAlignment(.center)

            Spacer()

            VStack(alignment: .center) {
                ZStack(alignment: .bottomTrailing) {
                    GeometryReader { geo in
                        Image(uiImage: viewModel.uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: 300)
                            .clipped()
                            .contentShape(Rectangle())
                            .gesture(
                                viewModel.isManualMode
                                    ? DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            viewModel.dragLocation =
                                                value.location
                                            viewModel.updateColorAndRGB(
                                                from: viewModel.dragLocation,
                                                in: geo.size
                                            )
                                        } : nil
                            )
                            .onAppear {
                                viewModel.getAverageColorInCenterRegion()
                                viewModel.dragLocation = CGPoint(
                                    x: geo.size.width / 2,
                                    y: geo.size.height / 2
                                )
                            }

                        if viewModel.isManualMode {
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 2)
                                .background(
                                    Circle().fill(viewModel.selectedColor)
                                )
                                .frame(width: 30, height: 30)
                                .position(viewModel.dragLocation)
                                .shadow(radius: 3)
                        }
                    }
                    .frame(height: 300)

                    Button {
                        viewModel.isManualMode.toggle()
                    } label: {
                        ZStack {
                            Rectangle()
                                .fill(.mughalGreen700)
                                .frame(width: 36, height: 36)
                                .cornerRadius(8)
                                .overlay(
                                    Rectangle()
                                        .fill(.white)
                                        .frame(width: 34, height: 34)
                                        .cornerRadius(8)
                                )
                            Image(systemName: "eyedropper")
                                .foregroundStyle(.mughalGreen700)
                        }
                    }
                    .padding()
                }
            }

            VStack(alignment: .center, spacing: 4) {
                Text("Your Soil Color")
                    .font(.h4)

                Rectangle()
                    .fill(viewModel.selectedColor)
                    .frame(height: 42)
                    .cornerRadius(8)

                Text(
                    "R: \(viewModel.redInt)  G: \(viewModel.greenInt)  B: \(viewModel.blueInt)"
                )
                .font(.caption)
                .foregroundStyle(.gray)
            }

            Spacer()
            Spacer()
            
            if let pH = viewModel.pH {
                Text("Calculated PH: \(pH.formatted())")
            } else {
                Text("Ph not calculated yet")
            }
   
            
            // Check ML Model works or not
            ActionButton(title: .next) {
                viewModel.calculatePH()
            }
        }
        .padding()
    }
}

#Preview {
    ConfirmColorView()
}
