//
//  WeatherView.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            switch viewModel.loadingState {
            case .loading:
                ProgressView()
            case .failed:
                Text("Couldn't load weather data.")
                    .font(.title2)
            case .loaded:
                if let weatherData = viewModel.weatherData {
                    VStack {
                        Text(weatherData.name)
                            .font(.largeTitle)
                        Text("Temperature: \(viewModel.temperature)")
                            .font(.title)
                        Text("min: \(viewModel.minTemperature), max:\(viewModel.maxTemperature)")
                    }
                }
            }
        }
        .onAppear {
            viewModel.getWeather()
        }
    }
}
