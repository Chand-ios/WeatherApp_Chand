//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Chand on 26/04/23.
//

import Foundation
struct WeatherModel: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone, id: Int?
    let name: String?
   // let cod: Int?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, description, icon: String?
    
    func getIcon()->String
    {
        
        switch icon
        {
        case "t01d","t02d","t03d","t01n","t02n","t03n" : return "cloud.bolt.rain"
        case "t04d","t04n","t05d","t05n": return "cloud.bolt"
        case "d01d","d01n","d02d","d02n","d03d","d03n": return "cloud.drizzle"
        case "r01d", "r01n","r02d","r02n": return "cloud.rain"
        case "r03d","r03n": return "cloud.heavyrain"
        case "f01d","f01n","r04d","r04n","r05d","r05n","r06d","r06n": return "cloud.rain"
        case "s01d","s01n","s02d","s02n","s03d","s03n","s04d","s04n": return "cloud.snow"
        case "s05d","s05n": return "cloud.sleet"
        case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n","a05d","a05n","a06d","a06n": return "smoke"
        case "c01d","c01n": return "sun.max"
        case "c02d", "c02n","c03d","c03n": return "cloud.sun"
        case "c04d","c04n": return "smoke"
        default:
            return "cloud"
        }
    }
}
// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
   // let gust: Double?
}
