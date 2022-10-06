//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation
import CoreLocation


class WeatherViewModel: ObservableObject {
    
    let latitude: Double
    let longitude: Double
    
    enum loadingState {
        case failed
        case loaded
        case loading
    }
    
    @Published var weatherData: WeatherData?
    @Published var loadingState: loadingState = .loaded
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func getWeather() {
        self.loadingState = .loading
        Task {
            let result: Result<WeatherData, NetworkError> = await RequestManager.shared.send(.weather(latitude: latitude, longitude: longitude))
            
            await MainActor.run {
                switch result {
                case .success(let data):
                    self.weatherData = data
                    self.loadingState = .loaded
                case .failure(let error):
                    print(error)
                    self.loadingState = .failed
                }
            }
            
        }
    }
    
    func searchForCity(with searchQuery: String) {
        Task {
            let result: Result<[City], NetworkError> = await RequestManager.shared.send(.citySearch(for: searchQuery))
            
            await MainActor.run {
                switch result {
                case .success(let data):
                    print(data)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Display
extension WeatherViewModel {
    var temperature: String {
        "\(round(weatherData?.main.temp ?? 0))"
    }
    
    var minTemperature: String {
        "\(round(weatherData?.main.temp_min ?? 0))"
    }
    
    var maxTemperature: String {
        "\(round(weatherData?.main.temp_max ?? 0))"
    }
    
}
