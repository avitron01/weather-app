//
//  WeatherData.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift

//MARK: - Realmable protocols
protocol Realmable {
    associatedtype Item
    var realmData: Item { get }
    static var realmType: Item.Type { get }
    
    init(realm: Item)
}

protocol RealmableObject: Realmable where Item: Object {
    var realmData: Item { get }
}

protocol RealmableEmbedded: Realmable where Item: EmbeddedObject {
    var realmData: Item { get }
}

//MARK: - Codable Models
struct WeatherData: Codable, RealmableObject {
    var id: Int //City ID
    var name: String //City name
    var weather: [Weather]
    var coordinate: Coordinate?
    var main: Main?
    var visibility: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case weather
        case coordinate = "coord"
        case main
        case visibility
    }
    
    var realmData: RealmWeatherData {
        return RealmWeatherData(weatherData: self)
    }
    
    static var realmType: RealmWeatherData.Type {
        return RealmWeatherData.self
    }
    
    init(realm: RealmWeatherData) {
        self.id = realm.id
        self.name = realm.name
        
        var weatherList: [Weather] = []
        
        for weather in realm.weather {
            weatherList.append(weather.codableObject)
        }
        
        self.weather = weatherList
        self.coordinate = realm.coordinate?.codableObject
        self.main = realm.main?.codableObject
        self.visibility = realm.visibility
    }
}

struct Weather: Codable, RealmableEmbedded {
    static var realmType: RealmWeather.Type {
        return RealmWeather.self
    }
    
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    var iconImageInfo: (isDayTime: Bool, iconName: String) {
        let dayInfo: String = icon.filter {
            return ($0 == "d" || $0 == "n")
        }
        
        var iconName = ""
        if let firstIndex = icon.firstIndex(of: Character(dayInfo)) {
            iconName = String(icon[..<firstIndex])
        }
                
        let isDayTime = (dayInfo == "d")
        return (isDayTime, iconName)
    }
    
    var realmData: RealmWeather {
        return RealmWeather(weather: self)
    }

    init(realm: RealmWeather) {
        self.id = realm.id
        self.main = realm.main
        self.description = realm.weatherDescription
        self.icon = realm.icon
    }
}

struct Coordinate: Codable, RealmableEmbedded {
    static var realmType: RealmCoordinate.Type {
        return RealmCoordinate.self
    }
    
    var lon: Float
    var lat: Float
    
    var realmData: RealmCoordinate {
        return RealmCoordinate(coordinate: self)
    }
    
    init(realm: RealmCoordinate) {
        self.lon = realm.lon
        self.lat = realm.lat
    }
}

struct Main: Codable, RealmableEmbedded {
    static var realmType: RealmMain.Type {
        return RealmMain.self
    }
    
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
    
    var realmData: RealmMain {
        return RealmMain(main: self)
    }
        
    init(realm: RealmMain) {
        self.temp = realm.temp
        self.feelsLike = realm.feelsLike
        self.tempMin = realm.tempMin
        self.tempMax = realm.tempMax
        self.pressure = realm.pressure
        self.humidity = realm.humidity
    }
}
