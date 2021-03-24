//
//  WeatherData.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation

struct WeatherData: Codable {
    var weather: [Weather]
    
    struct Weather: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
}
