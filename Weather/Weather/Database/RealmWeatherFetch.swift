//
//  RealmWeatherFetch.swift
//  Weather
//
//  Created by Avinash P on 27/03/21.
//

import Foundation

protocol RealmWeatherFetch {
    func recentlySearchedLocations() -> [WeatherData]
}

extension DatabaseManager: RealmWeatherFetch {
    func recentlySearchedLocations() -> [WeatherData] {
        var weathers: [WeatherData] = []
        let values = self.fetchValues(of: WeatherData.realmType)
        weathers = values.map { (weather) -> WeatherData in
            return weather.codableObject
        }
        
        return weathers
    }
    
    func fetchWeatherData(for location: String) -> WeatherData? {
        let values = self.fetchValues(of: WeatherData.realmType)
        let predicate = NSPredicate(format: "name contains[c] %@", location)
        let resultValue = values.filter(predicate)
        
        guard let codableValue = resultValue.first?.codableObject else {
            print("No values found in DB")
            return nil
        }
        
        return codableValue
    }
    
    func fetchWeatherFavouriteInfo(for id: Int) -> RealmFavouriteWeatherLocation? {
        return self.fetchValues(of: RealmFavouriteWeatherLocation.self, primaryKey: id)
    }
}
