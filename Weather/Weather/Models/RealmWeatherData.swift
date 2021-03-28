//
//  RealmWeatherData.swift
//  Weather
//
//  Created by Avinash P on 28/03/21.
//

import Foundation
import RealmSwift

protocol CodableObject where Item: Codable {
    associatedtype Item
    var codableObject: Item { get }
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

class RealmFavouriteWeatherLocation: Object {
    @objc dynamic var id: Int = 0 //City ID
    @objc dynamic var name: String = "" //City ID
    @objc dynamic var isFavorite: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(weather: WeatherData, isFavourite: Bool) {
        self.init()
        self.id = weather.id
        self.name = weather.name
        self.isFavorite = isFavourite
    }
}
