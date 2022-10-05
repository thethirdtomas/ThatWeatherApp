//
//  WeatherView.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
            default:
                if let weatherData = viewModel.weatherData {
                    Text("\(weatherData.name)")
                    
                } else {
                    Text("Search for you city")
                }
            }
        }
        .onAppear {
            switch viewModel.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                viewModel.requestLocation()
            default:
                viewModel.requestLocationPermission()
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
