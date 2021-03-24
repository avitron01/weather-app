//
//  WeatherServiceRequest.swift
//  Weather
//
//  Created by Avinash P on 24/03/21.
//

import Foundation

protocol WeatherServiceRequest {
    init?(url: WeatherURL, headers: [String : String]?)
}

extension URLRequest: WeatherServiceRequest {
    private static var apiKeyQueryItem: URLQueryItem {
        return URLQueryItem(name: "appid", value: WeatherServiceConstants.apiKey)
    }
    
    init?(url: WeatherURL, headers: [String : String]? = nil) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = WeatherURL.base.path
        urlBuilder.path = url.path
        urlBuilder.queryItems = url.query
        urlBuilder.queryItems?.append(URLRequest.apiKeyQueryItem)
        
        guard let resultURL = urlBuilder.url else {
            print("URL creation failed")
            return nil
        }
        
        self = URLRequest(url: resultURL)
        self.httpMethod = url.method.rawValue
        self.allHTTPHeaderFields = headers
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
