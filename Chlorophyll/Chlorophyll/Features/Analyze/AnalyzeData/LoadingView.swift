////
////  LoadingView.swift
////  Chlorophyll
////
////  Created by Syaoki Biek on 17/06/25.
////
//
//import SwiftUI
//
//struct LoadingView: View {
//    @StateObject var viewModel = AnalyzeDataViewModel()
//    let humidity: Double?
//    let temperature: Double?
//    let soilMoisture: Double?
//    let soilTemperature: Double?
//    let soilpH: Double?
//    
//    var body: some View {
//        VStack {
//            ProgressView("Loading...")
//                .progressViewStyle(CircularProgressViewStyle(tint: .green))
//                .scaleEffect(1.5)
//            Text("Please wait")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            Text("\(humidity ?? 0)%")
//                .font(.caption)
//                .foregroundColor(.gray)
//            Text("\(soilMoisture ?? 0)%")
//                .font(.caption)
//                .foregroundColor(.gray)
//            Text("\(soilTemperature ?? 0)°C")
//                .font(.caption)
//                .foregroundColor(.gray)
//            Text("\(soilpH ?? 0)")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            if let nitrogenLevel = viewModel.nitrogenLevel, let phosporusLevel = viewModel.phosphorusLevel, let potassiumLevel = viewModel.potassiumLevel {
//                Text("Nitrogen: \(nitrogenLevel)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("Phosphorus: \(phosporusLevel)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//                Text("Potassium: \(potassiumLevel)")
//                    .font(.caption)
//            }
//            
//            if let healthStatus = viewModel.plantHealth, let healthScore = viewModel.plantHealthProbability {
//                Text("Health: \(healthStatus) (\(healthScore)%)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            ActionButton(title: .submit) {
//                // write to test model
//                viewModel.predictNutrition(temp:soilMoisture, hum: humidity, moist: soilMoisture)
//                viewModel.predictHealth(moist: soilMoisture, temp: soilTemperature, hum: humidity, soilPH: soilpH)
//            }
//            
//            
//        }
//        .padding()
//    }
//}
//
//
//#Preview {
//    LoadingView(humidity: 0.0, temperature: 0.0, soilMoisture: 0.0, soilTemperature: 0.0, soilpH: 0.0)
//}
