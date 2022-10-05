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
            Text("Weather")
            
            if let location = viewModel.location {
                Text("Your location: \(location.latitude), \(location.longitude)")
            } else {
                Text("Search for you city")
            }
            
            Text("Auth: \(viewModel.authorizationStatus.rawValue)")
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
