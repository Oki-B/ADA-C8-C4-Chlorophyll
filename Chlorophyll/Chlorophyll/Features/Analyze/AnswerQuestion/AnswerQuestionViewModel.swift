//
//  Untitled.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import CoreML
import Foundation
import CoreLocation
import WeatherKit

@MainActor
class AnswerQuestionViewModel: NSObject, ObservableObject {
    @Published var temperature: Double?
    @Published var maxTemp: Double?
    @Published var minTemp: Double?
    @Published var humidity: Double?
    @Published var locationName: String = "Unknown"
    @Published var soilMoisturePrediction: Double?
    @Published var soilTempPrediction: Double?

    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func handleLocation(_ location: CLLocation) {
        Task {
            do {
                let weather = try await weatherService.weather(for: location)

                temperature = weather.currentWeather.temperature.value
                humidity = weather.currentWeather.humidity * 100
                
                if let todayForecast = weather.dailyForecast.first {
                    maxTemp = todayForecast.highTemperature.value
                    minTemp = todayForecast.lowTemperature.value
                }

                let geocoder = CLGeocoder()
                if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
                    locationName = placemark.locality ?? "Unknown"
                }
            } catch {
                print("Failed to get weather: \(error.localizedDescription)")
            }
        }
    }
    
    func calculateSoilMoisture()  {
        do {
            let config = MLModelConfiguration()
            let model = try SoilHumidRegression(configuration: config)
            var prediction: SoilHumidRegressionOutput!
            
            if let humidity = humidity, let temperature = temperature {
                prediction = try model.prediction(Humidity: humidity , Atmospheric_Temp: temperature )
            } else {
                soilMoisturePrediction = 0.0
            }
            
            print(prediction.Soil_Moisture)
            soilMoisturePrediction =  prediction.Soil_Moisture
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }
    
    func calculateSoilTemperature()  {
        do {
            let config = MLModelConfiguration()
            let model = try SoilTempRegression(configuration: config)
            var prediction: SoilTempRegressionOutput!
            
            if let humidity = humidity, let temperature = temperature {
                prediction = try model.prediction(Humidity: humidity, Atmospheric_Temp: temperature)
            } else {
                soilTempPrediction = 0.0
            }
            
            print(prediction.Soil_Temp)
            soilTempPrediction =  prediction.Soil_Temp
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }
    
    func getAllPredictions()  {
        calculateSoilMoisture()
        calculateSoilTemperature()
    }
}

// MARK: - CLLocationManagerDelegate
extension AnswerQuestionViewModel: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            self.handleLocation(location)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
