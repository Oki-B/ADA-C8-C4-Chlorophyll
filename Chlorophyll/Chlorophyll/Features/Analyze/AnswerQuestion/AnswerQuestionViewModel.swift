//
//  Untitled.swift
//  Chlorophyll
//
//  Created by Syaoki Biek on 16/06/25.
//

import CoreLocation
import CoreML
import Foundation
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
    @Published var indoorTemperature: Double?
    @Published var indoorHumidity: Double?

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
                if let placemark = try? await geocoder.reverseGeocodeLocation(
                    location
                ).first {
                    locationName = placemark.locality ?? "Unknown"
                }
            } catch {
                print("Failed to get weather: \(error.localizedDescription)")
            }
        }
    }

    func calculateSoilMoisture(hum: Double?, temp: Double?) {
        do {
            let config = MLModelConfiguration()
            let model = try SoilHumidRegression(configuration: config)
            var prediction: SoilHumidRegressionOutput!

            if let humidity = hum, let temperature = temp {
                prediction = try model.prediction(
                    Humidity: humidity,
                    Atmospheric_Temp: temperature
                )
            } else {
                soilMoisturePrediction = 0.0
            }

            print(prediction.Soil_Moisture)
            soilMoisturePrediction = prediction.Soil_Moisture
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    func calculateSoilTemperature(hum: Double?, temp: Double?) {
        do {
            let config = MLModelConfiguration()
            let model = try SoilTempRegression(configuration: config)
            var prediction: SoilTempRegressionOutput!

            if let humidity = hum, let temperature = temp {
                prediction = try model.prediction(
                    Humidity: humidity,
                    Atmospheric_Temp: temperature
                )
            } else {
                soilTempPrediction = 0.0
            }

            print(prediction.Soil_Temp)
            soilTempPrediction = prediction.Soil_Temp
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    func calculateIndoorTemperature() {
        do {
            let config = MLModelConfiguration()
            let model = try IndoorTempModel(configuration: config)
            var prediction: IndoorTempModelOutput!

            if let humidity = humidity, let temperature = temperature {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let hour = calendar.component(.hour, from: Date())

                let hour_sin = sin(2 * .pi * Double(hour) / 24)
                let hour_cos = cos(2 * .pi * Double(hour) / 24)
                let temp_diff = humidity - temperature
                let rh_ratio = humidity / temperature

                prediction = try model.prediction(
                    T_C_: temperature,
                    RH___: humidity,
                    T_RH: temperature * humidity,
                    hour_sin: hour_sin,
                    hour_cos: hour_cos,
                    temp_diff: temp_diff,
                    rh_ratio: rh_ratio
                )
            } else {
                indoorTemperature = 0.0
            }

            indoorTemperature = prediction.T_Indoor
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    func calculateIndoorHumidity() {
        do {
            let config = MLModelConfiguration()
            let model = try IndoorRHModel(configuration: config)
            var prediction: IndoorRHModelOutput!

            if let humidity = humidity, let temperature = temperature {
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.current
                let hour = calendar.component(.hour, from: Date())

                let hour_sin = sin(2 * .pi * Double(hour) / 24)
                let hour_cos = cos(2 * .pi * Double(hour) / 24)
                let temp_diff = humidity - temperature
                let rh_ratio = humidity / temperature

                prediction = try model.prediction(
                    T_C_: temperature,
                    RH___: humidity,
                    T_RH: temperature * humidity,
                    hour_sin: hour_sin,
                    hour_cos: hour_cos,
                    temp_diff: temp_diff,
                    rh_ratio: rh_ratio
                )
            } else {
                indoorHumidity = 0.0
            }

            indoorHumidity = prediction.RH_Indoor
        } catch {
            print("Error loading model: \(error.localizedDescription)")
        }
    }

    func getAllPredictions(option: Int) {
        if option == 1 {
            calculateIndoorTemperature()
            calculateIndoorHumidity()
            
            calculateSoilMoisture(hum: indoorHumidity, temp: indoorTemperature)
            calculateSoilTemperature(hum: indoorHumidity, temp: indoorTemperature)
        } else if option == 2 {
            calculateSoilMoisture(hum: humidity, temp: temperature)
            calculateSoilTemperature(hum: humidity, temp: temperature)
        }
    }

}

// MARK: - CLLocationManagerDelegate
extension AnswerQuestionViewModel: CLLocationManagerDelegate {
    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            self.handleLocation(location)
        }
    }

    nonisolated func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Location error: \(error.localizedDescription)")
    }
}
