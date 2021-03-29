//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation
import UIKit.UIImage

class WeatherViewModel {
    let weatherData: WeatherData
    let weatherLocation: String
    var isFavourite: Box<Bool> = Box(false)
    let weatherDescription: String?
    var weatherTemperature: String = "-"
    var weatherState: WeatherState?
    var weatherGradientColors: [CGColor]?
    var weatherImage: UIImage?
    var isDayTime: Bool = true
    var iconName: String?
    
    private var database: DatabaseManager = {
        return DatabaseManager.shared
    }()
    
    var otherWeatherData: [(field: String, value: String)]?
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.weatherLocation = weatherData.name
        self.weatherDescription = weatherData.weather.first?.description.capitalizingFirstLetter()
        
        if let favouriteInfo = database.fetchWeatherFavouriteInfo(for: weatherData.id) {
            self.isFavourite.value = favouriteInfo.isFavorite
        }
        
        if let temp = weatherData.main?.temp {
            self.weatherTemperature = "\(temp.rounded())°C"
        }
        if let currentWeatherInfo = weatherData.weather.first {
            self.initializeWeatherInfo(using: currentWeatherInfo)
        }
        self.initializeOtherWeatherData(using: weatherData)
    }
    
    func initializeWeatherInfo(using weather: Weather) {
        let iconInfo = weather.iconImageInfo
        self.isDayTime = iconInfo.isDayTime
        self.iconName = iconInfo.iconName
        
        let weatherState = WeatherState(rawValue: iconInfo.iconName)
        if let state = weatherState {
            self.weatherState = state
            self.weatherImage = UIImage(systemName: state.getImageName(isDayTime: isDayTime))?.withRenderingMode(.alwaysOriginal)
                .withTintColor(state.getTintColor(isDayTime: isDayTime))
            self.weatherGradientColors = state.getWeatherGradientColor(isDayTime: isDayTime)
        }
    }
    
    func initializeOtherWeatherData(using weatherData: WeatherData) {
        var otherData: [(field: String, value: String)] = []
        otherData.append(("Visibilty:", "\(weatherData.visibility / 1000) km"))
        
        if let main = weatherData.main {
            otherData.append(contentsOf: [("Feels like:", "\(main.feelsLike.rounded())°C"),
                                          ("Temp High:", "\(main.tempMax.rounded())°C"),
                                          ("Temp Low:", "\(main.tempMin.rounded())°C"),
                                          ("Pressure:", "\(main.pressure)hPa"),
                                          ("Humidity:", "\(main.humidity)%")])
        }
         
        self.otherWeatherData = otherData
    }

    func toggleIsFavourite() {
        self.isFavourite.value.toggle()
        let realmData = RealmFavouriteWeatherLocation(weather: self.weatherData, isFavourite: self.isFavourite.value)
        database.saveValue(realmData)
    }
}


enum WeatherState: String {
    case clearSky = "01"
    case fewClouds = "02"
    case scatteredClouds = "03"
    case brokenClouds = "04"
    case showerRain = "09"
    case rain = "10"
    case thunderStorm = "11"
    case snow = "13"
    case mist = "50"

    func getImageName(isDayTime: Bool) -> String {
        switch self {
        case .clearSky:
            return isDayTime ? "sun.max.fill" : "moon.fill"
        case .fewClouds:
            return isDayTime ? "cloud.sun.fill" : "cloud.moon.fill"
        case .scatteredClouds:
            return "cloud.fill"
        case .brokenClouds:
            return "smoke.fill"
        case .showerRain:
            return "cloud.drizzle.fill"
        case .rain:
            return isDayTime ? "cloud.sun.rain.fill" : "cloud.moon.rain.fill"
        case .thunderStorm:
            return isDayTime ? "cloud.sun.bolt.fill" : "cloud.moon.bolt.fill"
        case .snow:
            return "snow"
        case .mist:
            return "cloud.fog.fill"
        }
    }
    
    func getTintColor(isDayTime: Bool) -> UIColor {
        switch self {
        case .clearSky:
            return isDayTime ? .systemOrange : .white
        case .fewClouds:
            return isDayTime ? .systemOrange : .white
        case .scatteredClouds:
            return .white
        case .brokenClouds:
            return .white
        case .showerRain:
            return .systemGray
        case .rain:
            return .white
        case .thunderStorm:
            return isDayTime ? .systemOrange : .white
        case .snow:
            return .white
        case .mist:
            return .white
        }
    }
    
    func getWeatherGradientColor(isDayTime: Bool) -> [CGColor] {
        var gradientColors: [(red: CGFloat, green: CGFloat, blue: CGFloat)] = []
        
        //Can include further gradient color other weather conditions
        //For now we handle Day and Night gradients
        if isDayTime {
            gradientColors = [(61, 133, 192),
                              (61, 133, 192),
                              (175, 227, 255),
                              (227, 241, 245),
                              (140, 197, 240),
                              (61, 133, 192)]
        } else {
            gradientColors =  [(61, 133, 192),
                               (32, 86, 160),
                               (8, 37,93),
                               (17, 54, 119),
                               (17, 54, 119),
                               (32, 86, 160),
                               (61, 133, 192)]
        }
                            
        let cgColors = gradientColors.map {
            return UIColor(red: $0.red / 255, green: $0.green / 255, blue: $0.blue / 255, alpha: 1.0).cgColor
        }
        
        return cgColors
    }
}
