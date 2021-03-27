//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation
import UIKit.UIImage

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
            return isDayTime ? .systemOrange : .white
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
                              (175, 227, 255),
                              (227, 241, 255),
                              (253, 253, 253),
                              (140, 197, 240)]
        } else {
            gradientColors =  [(1, 22, 46),
                               (0, 29, 55),
                               (0, 39, 70),
                               (1, 49, 85),
                               (0, 58, 99),
                               (1, 66, 109)]
        }
                            
        let cgColors = gradientColors.map {
            return UIColor(red: $0.red / 255, green: $0.green / 255, blue: $0.blue / 255, alpha: 1.0).cgColor
        }
        
        return cgColors
    }
}

class WeatherViewModel {
    let weatherData: WeatherData
    let weatherLocation: String
    let weatherDescription: String?
    var weatherTemperature: String = "-"
    var weatherState: WeatherState?
    var weatherGradientColors: [CGColor]?
    var weatherImage: UIImage?
    var isDayTime: Bool = true
    var iconName: String?
    
    var otherWeatherData: [String]?
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.weatherLocation = weatherData.name
        
        if let temp = weatherData.main?.temp {
            self.weatherTemperature = "\(temp)°C"
        }
        
        self.weatherDescription = weatherData.weather.first?.description
        
        if let currentWeatherInfo = weatherData.weather.first {
            let iconInfo = currentWeatherInfo.iconImageInfo
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
    }
    
    

}
