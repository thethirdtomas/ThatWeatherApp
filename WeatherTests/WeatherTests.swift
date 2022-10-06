//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Tomas Torres on 10/4/22.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {

    func testSearchForCityNetworkFailure() async throws {
        let viewModel = SearchViewModel(network: MockNetwork(mockError: .unableToComplete))
        await viewModel.searchForCity(with: "San Antonio")
        
        XCTAssertEqual(viewModel.loadingState, .failed)
    }
    
    func testSearchForCityNetworkSuccessLoaded() async throws {
        let cities = [
            City(name: "San Antonio", state: "Texas", latitude: -123.1123, longitude: 321.123),
            City(name: "Houston", state: "Texas", latitude: -212.321, longitude: 21.123),
        ]
        
        let viewModel = SearchViewModel(network: MockNetwork(mockResult: cities))
        await viewModel.searchForCity(with: "Texas")
        
        XCTAssertEqual(viewModel.loadingState, .loaded)
        XCTAssert(viewModel.cities.count == 2)
    }
    
    func testSearchForCityNetworkSuccessEmpty() async throws {
        
        let viewModel = SearchViewModel(network: MockNetwork(mockResult: []))
        await viewModel.searchForCity(with: "Texas")
        
        XCTAssertEqual(viewModel.loadingState, .empty("Texas"))
        XCTAssert(viewModel.cities.isEmpty)
    }
    
    func testGetWeatherNetworkFailure() async throws {
        let viewModel = WeatherViewModel(network: MockNetwork(mockError: .unableToComplete))
        await viewModel.getWeather()
        
        XCTAssertEqual(viewModel.loadingState, .failed)
        XCTAssertNil(viewModel.weatherData)
    }
    
    func testGetWeatherNetworkSuccessLoaded() async throws {
        let weatherData = WeatherData(name: "San Antonio", main: Weather(temp: 0.0, temp_min: 0.0, temp_max: 0.0))
        
        
        let viewModel = WeatherViewModel(network: MockNetwork(mockResult: weatherData))
        await viewModel.getWeather()
        
        XCTAssertEqual(viewModel.loadingState, .loaded)
        XCTAssertNotNil(viewModel.weatherData)
        XCTAssertEqual(viewModel.weatherData!.name, "San Antonio")
    }
}
