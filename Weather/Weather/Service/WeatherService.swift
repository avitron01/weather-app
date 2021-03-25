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
            performDBUpdates(for: result)
            completion(result)
        }
    }
    
    private static func performDBUpdates(for weatherDataResult: Result<WeatherData>) {
        switch weatherDataResult {
        case .success(let weatherData):
            cacheWeatherData(for: weatherData.realmData)
            retrieveCachedData(for: RealmWeatherData.self)
        case .error(_):
            break
        }
    }
    
    private static func cacheWeatherData<T: Object>(for item: T) {
        database.saveValue(item)
    }
    
    private static func retrieveCachedData<T: Object>(for type: T.Type) -> Results<T> {
        return database.fetchValues(of: type)
    }
}
