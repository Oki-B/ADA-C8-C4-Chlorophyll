//
//  AnswerQuestionView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import SwiftUI

struct AnswerQuestionView: View {
    @StateObject private var viewModel = AnswerQuestionViewModel()
    @State var optionChoose: Int = 1

    var body: some View {
        VStack {
            StepBar(currentStep: 3)
            Spacer()

            HStack (spacing: 20){

                if let temperature = viewModel.temperature,
                    let humidity = viewModel.humidity,
                    let maxTemp = viewModel.maxTemp,
                    let minTemp = viewModel.minTemp
                {
                    VStack {
                        Text("\(String(format: "%.1f", temperature))°C")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.darkCharcoal300)
                        Text(
                            "min \(String(format: "%.1f", minTemp))° - max \(String(format: "%.1f", maxTemp))°"
                        )
                        .font(.caption)
                        .foregroundStyle(.darkCharcoal300)
                        
                        Text("Hum \(String(format: "%.1f", humidity))%"
                        )
                        .font(.title2)
                        .foregroundStyle(.darkCharcoal300)
                        .fontWeight(.medium)
                    }
                    
                    Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(.orange)
                    
                } else {
                    Text("Loading...")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                //                Text("\(viewModel.temperature)")
            }
            Spacer()
            Text("Tell us where your plant is located")
                .font(.h3)
                .foregroundStyle(.darkCharcoal700)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)

            HStack(spacing: 12) {

                // Option 1
                Button {
                    optionChoose = 1
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.mughalGreen300)
                            .cornerRadius(12)
                            .frame(width: 150, height: 200)
                            .clipped()
                            .overlay {
                                VStack(spacing: 12) {
                                    Image("plant-indoor")
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 150)

                                    Text("Indoor")
                                        .font(.baseMedium)
                                        .foregroundStyle(
                                            optionChoose == 1
                                                ? .cultured300
                                                : .darkCharcoal500
                                        )
                                        .padding(.bottom)
                                }
                                .frame(width: 148, height: 198)
                                .background(optionChoose == 1 ? .clear : .white)
                                .cornerRadius(12)
                            }

                    }

                }

                // Option 2
                Button {
                    optionChoose = 2
                } label: {
                    ZStack {
                        Rectangle()
                            .fill(.mughalGreen300)
                            .cornerRadius(12)
                            .frame(width: 150, height: 200)
                            .clipped()
                            .overlay {
                                VStack(spacing: 12) {
                                    Image("plant-outdoor")
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                        .frame(width: 150)

                                    Text("Outdoor")
                                        .font(.baseMedium)
                                        .foregroundStyle(
                                            optionChoose == 2
                                                ? .cultured300
                                                : .darkCharcoal500
                                        )
                                        .padding(.bottom)
                                }
                                .frame(width: 148, height: 198)
                                .background(optionChoose == 2 ? .clear : .white)
                                .cornerRadius(12)
                            }

                    }

                }

            }
            .frame(maxWidth: 280)

            Spacer()
            Spacer()
            
            // Check Model Works or not
            Text("Predition Output")
            if let soilMoisture = viewModel.soilMoisturePrediction, let soilTemperature = viewModel.soilTempPrediction {
                Text("Soil Moisture :\(String(format: "%.1f", soilMoisture)) / Soil Temperature : \(String(format: "%.1f", soilTemperature))°C")
            } else {
                Text("No prediction yet")
            }


            ActionButton(
                title: .submit,
                action: {
                    // action for answer color and get prediction
                    
                    // test check model
                    viewModel.getAllPredictions()
                }
            )

        }
        .padding()

    }

}

#Preview {
    AnswerQuestionView()
}
