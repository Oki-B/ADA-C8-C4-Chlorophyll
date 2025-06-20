//
//  AnalyzeDataViewModel.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 17/06/25.
//

import CoreML
import Foundation

class AnalyzeDataViewModel: ObservableObject {
    @Published var result: String?
    @Published var error: Error?
    @Published var isAnalyzing = false
    @Published var nitrogenLevel: Double?
    @Published var phosphorusLevel: Double?
    @Published var potassiumLevel: Double?

    @Published var plantHealth: String?
    @Published var plantHealthProbability: [String: Double]?

    func predictHealth(moist: Double? = nil, temp: Double? = nil, hum: Double? = nil, soilPH: Double? = nil) {
        do {
            let config = MLModelConfiguration()
            let model = try PlantStressClassifier(configuration: config)

            var prediction: PlantStressClassifierOutput!
            
            if let moist = moist, let temp = temp, let hum = hum, let soilPH = soilPH {
                prediction = try model.prediction(
                    Soil_Moisture: moist,
                    Soil_Temperature: temp,
                    Humidity: hum,
                    Soil_pH: soilPH,
                    Nitrogen_Level: nitrogenLevel ?? 0.0,
                    Phosphorus_Level: phosphorusLevel ?? 0.0,
                    Potassium_Level: potassiumLevel ?? 0.0
                )
            }
            
            plantHealth = prediction.Plant_Health_Status
            plantHealthProbability = prediction.Plant_Health_StatusProbability


        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    func predictNutrition(
        temp: Double? = nil,
        hum: Double? = nil,
        moist: Double? = nil
    ) {
        do {
            let config = MLModelConfiguration()
            let nitrogenModel = try NitrogenRegressor(configuration: config)
            let phosporusModel = try PhosphorousRegressor(configuration: config)
            let potassiumModel = try PotassiumRegressor(configuration: config)

            var nitrogenPrediction: NitrogenRegressorOutput!
            var phosporusPrediction: PhosphorousRegressorOutput!
            var potassiumPrediction: PotassiumRegressorOutput!

            if let humidity = hum, let temperature = temp, let moisture = moist
            {
                nitrogenPrediction = try nitrogenModel.prediction(
                    Temparature: temperature,
                    Humidity: humidity,
                    Moisture: moisture
                )
                phosporusPrediction = try phosporusModel.prediction(
                    Temparature: temperature,
                    Humidity: humidity,
                    Moisture: moisture
                )
                potassiumPrediction = try potassiumModel.prediction(
                    Temparature: temperature,
                    Humidity: humidity,
                    Moisture: moisture
                )

            } else {
                nitrogenLevel = 0.0
                phosphorusLevel = 0.0
                potassiumLevel = 0.0
            }

            nitrogenLevel = nitrogenPrediction.Nitrogen
            phosphorusLevel = phosporusPrediction.Phosphorous
            potassiumLevel = potassiumPrediction.Potassium

        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }
    
    func predictStress(n:String, p: String, k: String, temp: Double, humid: Double, soilpH: Double) -> String {
        var total_ideal : Int = 0
        
        if temp >= 16 && temp <= 30 {
            total_ideal = total_ideal + 1
        }
        
        if humid >= 50 && humid <= 70 {
            total_ideal = total_ideal + 1
        }
        
        if soilpH >= 5.5 && soilpH <= 7 {
            total_ideal = total_ideal + 1
        }
        
        if n != "Low" {
            total_ideal = total_ideal + 1
        }
        
        if p != "Low" {
            total_ideal = total_ideal + 1
        }
        
        if k != "Low" {
            total_ideal = total_ideal + 1
        }
        
        if total_ideal >= 5 && total_ideal <= 6 {
            return "Healthy"
        } else if total_ideal >= 2 && total_ideal <= 4 {
            return "Moderate Stress"
        } else {
            return "High Stress"
        }
    }
    
    func getImage(stress: String) -> String {
        if stress == "High Stress" {
            return "stress"
        } else if stress == "Moderate Stress" {
            return "mid"
        } else {
            return "happy"
        }
    }
    
    func contentResult(stress: String) -> String {
        if stress == "High Stress" {
            return "Poor soil condition, roots struggling—Calathea deeply stressed, needs care. 🛠️"
        } else if stress == "Moderate Stress" {
            return "Soil needs care—too dry or wet, Calathea feeling stressed. 💧"
        } else {
            return "Moist, balanced soil—your Calathea likely happy and thriving! 🌱"
        }
    }
}
