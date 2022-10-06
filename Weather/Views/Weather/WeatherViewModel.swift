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
    let network: Network
    
    init(latitude: Double = 0.0, longitude: Double = 0.0, network: Network = RequestManager.shared) {
        self.latitude = latitude
        self.longitude = longitude
        self.network = network
    }
}

// MARK: - Network
extension WeatherViewModel {
    func getWeather() async {
        await MainActor.run {
            self.loadingState = .loading
        }
       
        let result: Result<WeatherData, NetworkError> = await network.send(.weather(latitude: latitude, longitude: longitude))
        
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
