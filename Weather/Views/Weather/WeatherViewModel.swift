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
            self.getWeatherUsingLocation(location)
        } else {
            self.loadingState = .loaded
        }
    }
    
    private func getWeatherUsingLocation(_ location: CLLocationCoordinate2D) {
        Task {
            let result = await WeatherAPI.shared.getWeatherUsingLocation(location)
            
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
