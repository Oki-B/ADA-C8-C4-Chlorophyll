//
//  AnswerQuestionView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI

struct AnswerQuestionView: View {
    @StateObject private var viewModel = AnswerQuestionViewModel()
    @State var showAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    let soilpH: Double?
    @State var optionChoose: Int = 1
    @State private var navigatetoResult: Bool = false
    @State private var isDisabled: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                StepBar(currentStep: 3)
                Spacer()

                HStack {
                    if let temperature = viewModel.temperature,
                        let humidity = viewModel.humidity,
                        let maxTemp = viewModel.maxTemp,
                        let minTemp = viewModel.minTemp
                    {
                        VStack(alignment: .leading) {
                            Text("\(viewModel.locationName)")
                                .font(.title3)
                                .bold()
//                                .foregroundStyle(.darkCharcoal300)
                            Text("My Location")
                                .font(.caption)
                                .foregroundStyle(.cultured500)
                                .fontWeight(.semibold)
                                

                            Text(
                                "Humidity: \(String(format: "%.1f", humidity))%"
                            )
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding(.top, 8)
                        }
                        .padding()
                        
                        
                        Spacer()
                        
                        VStack {
                            Text("\(String(format: "%.1f", temperature))°C")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                            Text(
                                "\(String(format: "%.1f", minTemp))° - \(String(format: "%.1f", maxTemp))°"
                            )
                            .font(.subheadline)
                        }
                        .padding()

                    } else {
                        Spacer()
                        ProgressView("Fetching Weather Information...")
                            .padding()
                        Spacer()

                    }
                }
                .foregroundStyle(.cultured300)
                .background(.mughalGreen300)
                .cornerRadius(24)
                .shadow(color: .midGreenYellow500,radius: 4)
                
                
                Spacer()
                Text("Help us know your plant's spot")
                    .font(.h3)
                    .foregroundStyle(.darkCharcoal700)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 24)
                    .frame(width: 240)
                HStack(spacing: 24) {

                    // Option 1
                    Button {
                        optionChoose = 1
                    } label: {
                        VStack (alignment: .leading) {
                            Image("plant-indoor")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: 125, height: 125)
                                .cornerRadius(12)
                                .padding(.top, 8)
                            
                            VStack (alignment: .leading) {
                                Text("Indoor")
                                    .font(.h1)
                                    .foregroundStyle(.darkCharcoal700)
                                Text("My plant seeing all from inside")
                                    .font(.custom("Manrope-Regular", size: 8))
                                    .foregroundStyle(.darkCharcoal300)
                            }
                            .frame( width: 125, alignment: .leading)
                            .padding(.bottom, 20)

                        }
                        .padding(.horizontal,6)
                        .background(.cultured300)
                        .cornerRadius(12)
                        .shadow(color: .mughalGreen500,radius: optionChoose == 1 ? 4 : 0)
                    }

                    // Option 2
                    Button {
                        optionChoose = 2
                    } label: {
                        VStack (alignment: .leading) {
                            Image("plant-outdoor")
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: 125, height: 125)
                                .cornerRadius(12)
                                .padding(.top, 8)
                            
                            VStack (alignment: .leading) {
                                Text("Outdoor")
                                    .font(.h1)
                                    .foregroundStyle(.darkCharcoal700)
                                Text("My plant have enough sunlight")
                                    .font(.custom("Manrope-Regular", size: 8))
                                    .foregroundStyle(.darkCharcoal300)

                            }
                            .frame( width: 125, alignment: .leading)
                            .padding(.bottom, 20)

                        }
                        .padding(.horizontal,6)
                        .background(.cultured300)
                        .cornerRadius(12)
                        .shadow(color: .mughalGreen500,radius: optionChoose == 2 ? 4 : 0)
                    }
                }

                Spacer()
                Spacer()

                ActionButton(
                    title: .submit,
                    action: {
                        // action for answer color and get prediction
                        if let soilpH = soilpH, let soilMoisture = viewModel.soilMoisturePrediction,
                           let soilTemperature = viewModel.soilTempPrediction {
                            print("Soil pH : \(soilpH) Soil Moisture :\(String(format: "%.1f", soilMoisture)) / Soil Temperature : \(String(format: "%.1f", soilTemperature))°C")
                        } else {
                            print("No prediction yet")
                        }

                        // test check model
                        viewModel.getAllPredictions(option: optionChoose)

                        navigatetoResult = true
                    }
                )
                .disabled(viewModel.temperature == nil)
                .navigationDestination(
                    isPresented: $navigatetoResult,
                    destination: {
                        LoadingView(
                            humidity: viewModel.humidity,
                            temperature: viewModel.temperature,
                            soilMoisture: viewModel.soilMoisturePrediction,
                            soilTemperature: viewModel.soilTempPrediction,
                            soilpH: soilpH
                        )
                    }
                )

            }
            .padding()
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

#Preview {
    AnswerQuestionView(soilpH: 6.98)
}
