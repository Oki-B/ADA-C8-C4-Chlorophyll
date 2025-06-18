//
//  ConfirmColorView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI

struct ConfirmColorView: View {

    let normalPhoto: UIImage?
    let constantColorImage: UIImage?
    @StateObject private var viewModel: ConfirmColorViewModel
    @State private var navigateToNextScreen: Bool = false

    private var uiImage: UIImage {
        if let normalPhoto = normalPhoto {
            return normalPhoto
        } else if let constantColorImage = constantColorImage {
            return constantColorImage
        } else {
            return UIImage(named: "soil-sample")!
        }
    }

    // The view initializer for the photos tab view.
    init(normalPhoto: UIImage? = nil, constantColorImage: UIImage? = nil) {
        self.constantColorImage = constantColorImage
        self.normalPhoto = normalPhoto
        _viewModel = StateObject(
            wrappedValue: ConfirmColorViewModel(
                uiImage: {
                    if let normalPhoto = normalPhoto {
                        return normalPhoto
                    } else if let constantColorImage = constantColorImage {
                        return constantColorImage
                    } else {
                        return UIImage(named: "soil-sample")!
                    }
                }()
            )
        )
    }

    var body: some View {
        NavigationStack {
            
            StepBar(currentStep: 2)
            Spacer()

            VStack(alignment: .center) {
                GeometryReader { geo in
                    ZStack(alignment: .bottomTrailing) {
                        // Photo
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: geo.size.width,
                                height: geo.size.height
                            )
                            //                            .clipped()
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
                            ZStack (alignment: .leading) {
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 140, height: 36)
                                    .cornerRadius(8)
                                    
                                HStack {
                                    Rectangle()
                                        .fill(viewModel.selectedColor)
                                        .frame(width: 24, height: 24)
    //                                    .cornerRadius(8)
                                    Text("\(viewModel.redInt), \(viewModel.greenInt), \(viewModel.blueInt)")
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
                        }
                        .padding()

                    }
                    .frame(height: geo.size.height)
                }
            }


            Spacer()
            

            if let pH = viewModel.pH {
                Text("Calculated PH: \(pH.formatted())")
            } else {
                Text("Ph not calculated yet")
            }

            // Check ML Model works or not
            ActionButton(title: .next) {
                viewModel.calculatePH()
                navigateToNextScreen = true
            }
            .navigationDestination(isPresented: $navigateToNextScreen, destination: {AnswerQuestionView(soilpH: viewModel.pH)})
            
        }
        

        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("Close")
            }
        }
    }
}

#Preview {
    ConfirmColorView()
}
