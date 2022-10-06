//
//  City.swift
//  Weather
//
//  Created by Tomas Torres on 10/4/22.
//

import Foundation

struct City: Decodable, Identifiable {
    var id: UUID {UUID()}
    let name: String
    let state: String
    let latitude: Double
    let longitude: Double
}

extension City {
    enum CodingKeys: String, CodingKey {
        case name
        case state
        case latitude = "lat"
        case longitude = "lon"
    }
}
