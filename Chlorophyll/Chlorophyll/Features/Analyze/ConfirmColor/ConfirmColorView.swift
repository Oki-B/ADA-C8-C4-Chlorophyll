//
//  ConfirmColorView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI

struct ConfirmColorView: View {
    @State var showAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ConfirmColorViewModel

    var body: some View {
        NavigationStack {

            StepBar(currentStep: 2)
            Spacer()

            VStack(alignment: .center) {
                GeometryReader { geo in
                    ZStack(alignment: .bottomTrailing) {
                        // Photo
                        Image(uiImage: viewModel.uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height
                            )
                            .clipped()
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
                                viewModel.getDominantColorInCenterRegion()

                                DispatchQueue.main.async {
                                    let center = CGPoint(
                                        x: geo.size.width / 2,
                                        y: geo.size.height / 2
                                    )
                                    viewModel.dragLocation = center
                                    viewModel.updateColorAndRGB(
                                        from: center,
                                        in: geo.size
                                    )
                                }

                            }

                        // Color Picker Pointer
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

                        HStack {
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(.neutral400)
                                    .frame(width: 140, height: 36)
                                    .cornerRadius(8)

                                HStack {
                                    Rectangle()
                                        .fill(viewModel.selectedColor)
                                        .frame(width: 24, height: 24)

                                    Text(
                                        "\(viewModel.redInt), \(viewModel.greenInt), \(viewModel.blueInt)"
                                    )
                                    .font(.smallMedium)
                                }
                                .padding(.leading)
                            }

                            // Button Color Picker Control
                            Button {
                                viewModel.isManualMode.toggle()
                            } label: {
                                ZStack {
                                    Rectangle()
                                        .fill(.mughalGreen500)
                                        .frame(width: 36, height: 36)
                                        .cornerRadius(8)
                                        .overlay(
                                            Rectangle()
                                                .fill(.midGreenYellow300)
                                                .frame(width: 34, height: 34)
                                                .cornerRadius(8)
                                        )
                                    Image(systemName: "eyedropper")
                                        .foregroundStyle(.mughalGreen700)
                                }
                            }
                        }
                        .padding(8)

                    }

                }
            }

            Spacer()

            // Check ML Model works or not
            ActionButton(title: .next) {
                // for check model
                viewModel.calculatePH()
                if let pH = viewModel.pH {
                    print("Calculated PH: \(pH.formatted())")
                }
                
                viewModel.calculateNPK()
                if let nPrediction = viewModel.nPrediction,
                   let pPrediction = viewModel.pPrediction,
                   let kPrediction = viewModel.kPrediction {
                    print("Calculated N: \(nPrediction)")
                    print("Calculated P: \(pPrediction)")
                    print("Calculated K: \(kPrediction)")
                }
                // navigate
                viewModel.navigateToNextView = true
            }
            .navigationDestination(
                isPresented: $viewModel.navigateToNextView,
                destination: { AnswerQuestionView(soilpH: viewModel.pH, nPrediction: viewModel.nPrediction, pPrediction: viewModel.pPrediction, kPrediction: viewModel.kPrediction) }
            )

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Close") {
                    showAlert = true
                }
            }
        }
        .alert("Are you sure?", isPresented: $showAlert) {
            Button("Yes", role: .destructive) {
                dismiss()
            }
            Button("Cancel", role: .cancel) {
            }
        } message : {
            Text("Doing this will make your progress reset.")
        }
    }
}

extension ConfirmColorViewModel {
    static var preview: ConfirmColorViewModel {
        ConfirmColorViewModel(normalPhoto: UIImage(named: "soil-sample"))
    }
}

#Preview {
    ConfirmColorView(viewModel: .preview)
}
