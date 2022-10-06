//
//  WeatherData.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation


struct WeatherData: Decodable {
    let name: String
    let main: Weather
}

struct Weather: Decodable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
}
