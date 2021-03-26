//
//  WeatherData.swift
//  Weather
//
//  Created by Avinash P on 25/03/21.
//

import Foundation
import RealmSwift

//MARK: - Realmable & CodableObject protocols
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

protocol CodableObject where Item: Codable {
    associatedtype Item
    var codableObject: Item { get }
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

//MARK: - Realm models
class RealmWeatherData: Object, CodableObject {
    @objc dynamic var id: Int = 0 //City ID
    @objc dynamic var name: String = "" //City name
    let weather = List<RealmWeather>()
    @objc dynamic var coordinate: RealmCoordinate?
    @objc dynamic var main: RealmMain?
    @objc dynamic var visibility: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var codableObject: WeatherData {
        return WeatherData(realm: self)
    }
    
    convenience init(weatherData: WeatherData) {
        self.init()
        self.id = weatherData.id
        self.name = weatherData.name
        
        let realWeathers = weatherData.weather.map { (weather) -> RealmWeather in
            return weather.realmData
        }
        
        self.weather.append(objectsIn: realWeathers)
        self.coordinate = weatherData.coordinate?.realmData
        self.main = weatherData.main?.realmData
        self.visibility = weatherData.visibility
    }
}

class RealmWeather: EmbeddedObject, CodableObject {
    @objc dynamic var id: Int = 0
    @objc dynamic var main: String = ""
    @objc dynamic var weatherDescription: String = ""
    @objc dynamic var icon: String = ""
    
    var codableObject: Weather {
        return Weather(realm: self)
    }
    
    convenience init(weather: Weather) {
        self.init()
        self.id = weather.id
        self.main = weather.main
        self.weatherDescription = weather.description
        self.icon = weather.icon
    }
}

class RealmCoordinate: EmbeddedObject, CodableObject {
    @objc dynamic var lon: Float = 0.0
    @objc dynamic var lat: Float = 0.0
    
    var codableObject: Coordinate {
        return Coordinate(realm: self)
    }
    
    convenience init(coordinate: Coordinate) {
        self.init()
        self.lon = coordinate.lon
        self.lat = coordinate.lat
    }
}

class RealmMain: EmbeddedObject, CodableObject {
    @objc dynamic var temp: Float = 0.0
    @objc dynamic var feelsLike: Float = 0.0
    @objc dynamic var tempMin: Float = 0.0
    @objc dynamic var tempMax: Float = 0.0
    @objc dynamic var pressure: Float = 0.0
    @objc dynamic var humidity: Float = 0.0
    
    var codableObject: Main {
        return Main(realm: self)
    }
    
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
