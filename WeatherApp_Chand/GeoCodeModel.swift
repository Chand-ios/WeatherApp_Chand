//
//  GeoCodeModel.swift
//  WeatherApp
//
//  Created by Chand on 26/04/23.
//

import Foundation
struct GeoCodeModel: Codable {
    let name: String
    let localNames: [String: String]
    let lat, lon: Double
    let country, state: String

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case lat, lon, country, state
    }
}
