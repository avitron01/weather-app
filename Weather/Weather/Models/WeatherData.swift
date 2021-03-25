//
//  WeatherData.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift

class WeatherData: Codable {
    var id: Int //City ID
    var name: String //City name
    var weather: [Weather]
    var coordinate: Coordinate
    var main: Main
    var visibility: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case weather
        case coordinate = "coord"
        case main
        case visibility
    }
}

class Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Coordinate: Codable {
    var lon: Float
    var lat: Float
}

struct Main: Codable {
    var temp: Float
    var feelsLike: Float
    var tempMin: Float
    var tempMax: Float
    var pressure: Float
    var humidity: Float

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}
