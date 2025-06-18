////
////  AnalyzeDataViewModel.swift
////  Chlorophyll
////
////  Created by Syaoki Biek on 17/06/25.
////
//
//import CoreML
//import Foundation
//
//class AnalyzeDataViewModel: ObservableObject {
//    @Published var result: String?
//    @Published var error: Error?
//    @Published var isAnalyzing = false
//    @Published var nitrogenLevel: Double?
//    @Published var phosphorusLevel: Double?
//    @Published var potassiumLevel: Double?
//
//    @Published var plantHealth: String?
//    @Published var plantHealthProbability: [String: Double]?
//
//    func predictHealth(moist: Double? = nil, temp: Double? = nil, hum: Double? = nil, soilPH: Double? = nil) {
//        do {
//            let config = MLModelConfiguration()
//            let model = try PlantStressClassifier(configuration: config)
//
//            var prediction: PlantStressClassifierOutput!
//            
//            if let moist = moist, let temp = temp, let hum = hum, let soilPH = soilPH {
//                prediction = try model.prediction(
//                    Soil_Moisture: moist,
//                    Soil_Temperature: temp,
//                    Humidity: hum,
//                    Soil_pH: soilPH,
//                    Nitrogen_Level: nitrogenLevel ?? 0.0,
//                    Phosphorus_Level: phosphorusLevel ?? 0.0,
//                    Potassium_Level: potassiumLevel ?? 0.0
//                )
//            }
//            
//            plantHealth = prediction.Plant_Health_Status
//            plantHealthProbability = prediction.Plant_Health_StatusProbability
//
//
//        } catch {
//            print("Error loading model: \(error.localizedDescription)")
//        }
//    }
//
//    func predictNutrition(
//        temp: Double? = nil,
//        hum: Double? = nil,
//        moist: Double? = nil
//    ) {
//        do {
//            let config = MLModelConfiguration()
//            let nitrogenModel = try NitrogenRegressor(configuration: config)
//            let phosporusModel = try PhosphorousRegressor(configuration: config)
//            let potassiumModel = try PotassiumRegressor(configuration: config)
//
//            var nitrogenPrediction: NitrogenRegressorOutput!
//            var phosporusPrediction: PhosphorousRegressorOutput!
//            var potassiumPrediction: PotassiumRegressorOutput!
//
//            if let humidity = hum, let temperature = temp, let moisture = moist
//            {
//                nitrogenPrediction = try nitrogenModel.prediction(
//                    Temparature: temperature,
//                    Humidity: humidity,
//                    Moisture: moisture
//                )
//                phosporusPrediction = try phosporusModel.prediction(
//                    Temparature: temperature,
//                    Humidity: humidity,
//                    Moisture: moisture
//                )
//                potassiumPrediction = try potassiumModel.prediction(
//                    Temparature: temperature,
//                    Humidity: humidity,
//                    Moisture: moisture
//                )
//
//            } else {
//                nitrogenLevel = 0.0
//                phosphorusLevel = 0.0
//                potassiumLevel = 0.0
//            }
//
//            nitrogenLevel = nitrogenPrediction.Nitrogen
//            phosphorusLevel = phosporusPrediction.Phosphorous
//            potassiumLevel = potassiumPrediction.Potassium
//
//        } catch {
//            print("Error loading model: \(error.localizedDescription)")
//        }
//    }
//}
