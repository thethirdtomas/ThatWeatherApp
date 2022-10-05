//
//  WeatherAPI.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation
import CoreLocation

enum WeatherAPIError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

class WeatherAPI {
    static let shared = WeatherAPI()
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let host = "api.openweathermap.org"
    let path = "/data/2.5/weather"
    
    private init() {}
    
    func getWeatherUsingLocation(_ location: CLLocationCoordinate2D) async -> Result<WeatherData, WeatherAPIError>  {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.host
        components.path = self.path
        components.queryItems = [
            URLQueryItem(name: "units", value: "imperial"),
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: "164d59a36ff8cfa92e3598547878597f"),
        ]
        
        guard let urlString = components.string else {
            return .failure(.invalidURL)
        }
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        do {
            // Calls Weather API
            let (data, response) = try await URLSession.shared.data(from: url)
   
            
            // Invalid response status code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return .failure(.invalidResponse)
            }
            
            // Json decode response data
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            return .success(decodedData)
            
        } catch is DecodingError {
            return .failure(.invalidData)
        } catch {
            return .failure(.unableToComplete)
        }
    }
}
