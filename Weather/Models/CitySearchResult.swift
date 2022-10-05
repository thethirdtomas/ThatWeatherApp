//
//  CitySearchResult.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation

struct City: Decodable {
    let name: String
    let state: String
    let lat: Float
    let lon: Float
    
}
