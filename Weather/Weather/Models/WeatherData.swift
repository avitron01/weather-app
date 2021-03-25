//
//  WeatherData.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift

protocol Realmable {
    associatedtype Item: Object
    var realmData: Item { get }
}

protocol RealmableEmbedded {
    associatedtype Item: EmbeddedObject
    var realmEmbeddedData: Item { get }
}

struct WeatherData: Codable, Realmable {
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
    
    var realmData: RealmWeatherData {
        return RealmWeatherData(weatherData: self)
    }
}

struct Weather: Codable, RealmableEmbedded {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    var realmEmbeddedData: RealmWeather {
        return RealmWeather(weather: self)
    }
}

struct Coordinate: Codable, RealmableEmbedded {
    var lon: Float
    var lat: Float
    
    var realmEmbeddedData: RealmCoordinate {
        return RealmCoordinate(coordinate: self)
    }
}

struct Main: Codable, RealmableEmbedded {
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
    
    var realmEmbeddedData: RealmMain {
        return RealmMain(main: self)
    }
}

class RealmWeatherData: Object {
    @objc dynamic var id: Int = 0 //City ID
    @objc dynamic var name: String = "" //City name
    let weather = List<RealmWeather>()
    @objc dynamic var coordinate: RealmCoordinate?
    @objc dynamic var main: RealmMain?
    @objc dynamic var visibility: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(weatherData: WeatherData) {
        self.init()
        self.id = weatherData.id
        self.name = weatherData.name
        
        let realWeathers = weatherData.weather.map { (weather) -> RealmWeather in
            return weather.realmEmbeddedData
        }
        
        self.weather.append(objectsIn: realWeathers)
        self.coordinate = weatherData.coordinate.realmEmbeddedData
        self.main = weatherData.main.realmEmbeddedData
        self.visibility = weatherData.visibility
    }
}

class RealmWeather: EmbeddedObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var main: String = ""
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var icon: String = ""
    
    convenience init(weather: Weather) {
        self.init()
        self.id = weather.id
        self.main = weather.main
        self.weatherDescription = weather.description
        self.icon = weather.icon
    }
}

class RealmCoordinate: EmbeddedObject {
    @objc dynamic var lon: Float = 0.0
    @objc dynamic var lat: Float = 0.0
    
    convenience init(coordinate: Coordinate) {
        self.init()
        self.lon = coordinate.lon
        self.lat = coordinate.lat
    }
}

class RealmMain: EmbeddedObject {
    @objc dynamic var temp: Float = 0.0
    @objc dynamic var feelsLike: Float = 0.0
    @objc dynamic var tempMin: Float = 0.0
    @objc dynamic var tempMax: Float = 0.0
    @objc dynamic var pressure: Float = 0.0
    @objc dynamic var humidity: Float = 0.0
    
    convenience init(main: Main) {
        self.init()
        self.temp = main.temp
        self.feelsLike = main.feelsLike
        self.tempMin = main.tempMin
        self.tempMax = main.tempMax
        self.pressure = main.pressure
        self.humidity = main.humidity
    }
}
