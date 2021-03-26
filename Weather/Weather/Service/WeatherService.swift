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
                cacheWeatherData(for: weatherData.realmData)
            case .error(let error):
                if (error == WeatherServiceError.networkUnavailable) {
                    let values = retrieveCachedData(for: WeatherData.realmType)
                    let predicate = NSPredicate(format: "name contains[c] %@", location)
                    let resultValue = values.filter(predicate)
                    
                    guard let codableValue = resultValue.first?.codableObject else {
                        print("No values found in DB")
                        completion(result)
                        return
                    }
                    
                    completion(Result.success(codableValue))
                    return
                }
            }
            
            completion(result)
        }
    }
    
    private static func cacheWeatherData<T: Object>(for item: T) {
        database.saveValue(item)
    }
    
    private static func retrieveCachedData<T: Object>(for type: T.Type) -> Results<T> {
        return database.fetchValues(of: type)
    }
}
