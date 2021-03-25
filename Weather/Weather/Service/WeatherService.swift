//
//  WeatherService.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation

typealias CurrentWeatherServiceCompletion = (Result<WeatherData>) -> ()

protocol WeatherServiceProtcol {
    static func fetchCurrentWeather(for location: String, completion: @escaping CurrentWeatherServiceCompletion)
}

class WeatherService: WeatherServiceProtcol {
    private static var network: WeatherNetworkManager = {
        return WeatherNetworkManager.shared
    }()
    
    static func fetchCurrentWeather(for location: String, completion: @escaping CurrentWeatherServiceCompletion) {
        network.fetchData(for: .current(location), type: WeatherData.self) { result in
            completion(result)
        }
    }
}
