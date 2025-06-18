//
//  LoadingView.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 17/06/25.
//

import SwiftUI

struct LoadingView: View {
    @StateObject var viewModel = AnalyzeDataViewModel()
    let humidity: Double?
    let temperature: Double?
    let soilMoisture: Double?
    let soilTemperature: Double?
    let soilpH: Double?
    
    @State private var progress: CGFloat = 0.0
    @State private var percentage: Int = 0
    @State private var navigateToResult = false
    
    var body: some View {
        NavigationStack {
            VStack {
                StepBar(currentStep: 4)
                    .padding(.top, 32)

                Spacer()

                Text("we're analyzing your plant to give you the best insights! 🌱")
                    .font(.h2)
                    .frame(width: 320)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 32)

                ZStack {
                    // Background circle
                    Circle()
                        .stroke(lineWidth: 16)
                        .foregroundColor(Color.gray.opacity(0.2))

                    // Progress circle
                    Circle()
                        .trim(from: 0.0, to: progress)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.mughalGreen500, Color.mughalGreen500]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: progress)

                    // Text percentage
                    Text("\(percentage) %")
                        .font(.h1)
                        .fontWeight(.semibold)
                        .foregroundColor(.darkCharcoal300)
                }
                .frame(width: 150, height: 150)
                .onAppear {
                    animateProgress(to: 1.0, duration: 4.5)
                    
                    // write to test model
                    viewModel.predictNutrition(temp:soilMoisture, hum: humidity, moist: soilMoisture)
                    viewModel.predictHealth(moist: soilMoisture, temp: soilTemperature, hum: humidity, soilPH: soilpH)
                }

                Spacer()
                Spacer()
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToResult) {
                if let nitrogenLevel = viewModel.nitrogenLevel, let phosporusLevel = viewModel.phosphorusLevel, let potassiumLevel = viewModel.potassiumLevel, let plantHealth = viewModel.plantHealth {
                    AnalyzeView(pH: soilpH ?? 0, nitrogen: nitrogenLevel, phosphorus: phosporusLevel, potassium: potassiumLevel, plantHealth: plantHealth)
                }
 
            }
            .navigationBarBackButtonHidden(true)
        }
        .padding()
    }
    
    // animate function
    
    private func animateProgress(to target: CGFloat, duration: TimeInterval) {
        let steps = 100
        let stepDuration = duration / Double(steps)

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(i)) {
                self.progress = CGFloat(i) / CGFloat(steps)
                self.percentage = i

                if i == steps {
                    withAnimation {
                        self.navigateToResult = true
                    }
                }
            }
        }
    }
}


#Preview {
    LoadingView(humidity: 0.0, temperature: 0.0, soilMoisture: 0.0, soilTemperature: 0.0, soilpH: 0.0)
}
