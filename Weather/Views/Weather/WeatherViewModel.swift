//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation
import CoreLocation


class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    enum loadingState {
        case failed
        case loaded
        case loading
    }
    
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var weatherData: WeatherData?
    @Published var loadingState: loadingState = .loaded
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        self.loadingState = .loading
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate, weatherData == nil {
            self.getWeatherUsingLocation(latitude: location.latitude, longitude: location.longitude)
        } else {
            self.loadingState = .loaded
        }
    }
    
    func getWeatherUsingLocation(latitude: Double, longitude: Double) {
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
 
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            self.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
