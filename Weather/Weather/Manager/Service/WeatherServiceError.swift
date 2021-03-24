//
//  WeatherServiceError.swift
//  Weather
//
//  Created by Avinash P on 24/03/21.
//

import Foundation

enum WeatherServiceError: Error {
    case parseError
    case urlCreationError
    case decoding(Error?)
    case network(Error?)
    case noDataFound
    
    var localizedDescription: String {
        switch self {
        case .parseError:
            return "Error Parsing Object"
        case .urlCreationError:
            return "URL creation failed"
        case .decoding(let decodeError):
            let description = decodeError?.localizedDescription ?? ""
            return "Error Decoding object: \(description)"
        case .network(let networkError):
            let description = networkError?.localizedDescription ?? ""
            return "Error Decoding object: \(description)"
        case .noDataFound:
            return "No Data found"
        }
    }
}
