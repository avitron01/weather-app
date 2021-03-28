//
//  WeatherService.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift

typealias CurrentWeatherServiceCompletion = (Result<WeatherData>) -> ()

protocol WeatherServiceProtcol {
    static func fetchCurrentWeather(for location: String, completion: @escaping CurrentWeatherServiceCompletion)
}

class WeatherService: WeatherServiceProtcol {
    private static var network: WeatherNetworkManager = {
        return WeatherNetworkManager.shared
    }()
    
    private static var database: DatabaseManager = {
        return DatabaseManager.shared
    }()
    
    static func fetchCurrentWeather(for location: String, completion: @escaping CurrentWeatherServiceCompletion) {
        network.fetchData(for: .current(location), type: WeatherData.self) { result in
            switch result {
            case .success(let weatherData):
                database.saveValue(weatherData.realmData)
            case .error(let error):
                if (error == WeatherServiceError.networkUnavailable) {
                    guard let weatherData = database.fetchWeatherData(for: location) else {
                        print("No cached weather data found for \(location)")
                        completion(result)
                        return 
                    }
                    
                    completion(Result.success(weatherData))
                    return
                }
            }
            
            completion(result)
        }
    }
    
    static func fetchWeather(using cityID: String, completion: @escaping CurrentWeatherServiceCompletion) {
        network.fetchData(for: .city(cityID), type: WeatherData.self) { result in
            switch result {
            case .success(let weatherData):
                database.saveValue(weatherData.realmData)
            case .error(let error):
                if (error == WeatherServiceError.networkUnavailable) {
                    guard let weatherData = database.fetchWeatherData(cityID: cityID) else {
                        print("No cached weather data found for \(cityID)")
                        completion(result)
                        return
                    }
                    
                    completion(Result.success(weatherData))
                    return
                }
            }
            
            completion(result)
        }
    }
}
