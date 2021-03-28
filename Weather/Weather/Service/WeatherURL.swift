//
//  WeatherURL.swift
//  Weather
//
//  Created by Avinash P on 24/03/21.
//

import Foundation

enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

enum WeatherURL {
    typealias Location = String
    typealias CityID = String
    
    case base
    case current(Location)
    case city(CityID)
    
    var path: String {
        switch self {
        case .base:
            return "api.openweathermap.org"
        case .current(_):
            return "/data/2.5/weather"
        case .city(_):
            return "/data/2.5/weather"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .base, .current(_), .city(_):
            return .get
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .base:
            return nil
        case .current(let location):
            return [URLQueryItem(name: "q", value: location),
                    URLQueryItem(name: "units", value: "metric")]
        case .city(let cityID):
            return [URLQueryItem(name: "id", value: cityID),
                    URLQueryItem(name: "units", value: "metric")]
        }
    }
}

