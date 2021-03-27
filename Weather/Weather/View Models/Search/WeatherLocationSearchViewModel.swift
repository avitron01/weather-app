//
//  WeatherLocationSearchViewModel.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation
import UIKit.UIViewController

class WeatherLocationSearchViewModel {    
    var isLoading = Box(false)
    var errorHandler: Box<Error?> = Box(nil)
    
    let database: DatabaseManager = {
        return DatabaseManager.shared
    }()
    
    var recentlySearched: Box<[WeatherData]> = {
        return Box(DatabaseManager.shared.recentlySearchedLocations())
    }()
    
    func fetchWeatherData(for location: String) {
        self.isLoading.value = true
        WeatherService.fetchCurrentWeather(for: location) { (result) in
            self.isLoading.value = false
            switch result {
            case .success(let weatherData):
                self.presentWeatherDetailViewController(with: weatherData, context: UIViewController())
                self.recentlySearched.value = self.database.recentlySearchedLocations()
            case .error(let error):
                self.errorHandler.value = error
            }
        }
    }
    
    func fetchRecentlySearched() -> [WeatherData] {
        var weathers: [WeatherData] = []
        let values = database.fetchValues(of: WeatherData.realmType)
        weathers = values.map { (weather) -> WeatherData in
            return weather.codableObject
        }
        
        return weathers
    }
    
    func presentWeatherDetailViewController(with: WeatherData, context: UIViewController) {
        
    }
}
