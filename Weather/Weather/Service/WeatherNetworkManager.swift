//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by Avinash P on 24/03/21.
//

import Foundation
import Network

typealias WeatherAPICompletion<T> = (Result<T>) -> Void

enum Result<T> {
    case success(T)
    case error(WeatherServiceError)
}

final class WeatherNetworkManager {
    static let shared = WeatherNetworkManager()
    private let decoder = JSONDecoder()
    private var monitor: NWPathMonitor
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
//        config.waitsForConnectivity = true
//        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config)
    }()

    init() {
        self.monitor = NWPathMonitor()
        configureNetworkMonitor()
    }
    
    func configureNetworkMonitor() {
//        self.monitor.pathUpdateHandler = { [weak self] path in
//            self?.isNetworkAvailable = (path.status == .satisfied)
//        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    public func fetchData<T: Codable>(for endpoint: WeatherURL, type: T.Type, completion: @escaping WeatherAPICompletion<T>) {
        guard let urlRequest = URLRequest(url: endpoint) else {
            completion(.error(.urlCreationError))
            return
        }
        
        self.session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                if self.monitor.currentPath.status != .satisfied {
                    DispatchQueue.main.sync {
                        completion(.error(.networkUnavailable))
                    }
                    return
                }
                
                DispatchQueue.main.sync {
                    completion(.error(.network(error)))
                }
                return
            }
            
            guard let jsonData = data else {
                DispatchQueue.main.sync {
                    completion(.error(.noDataFound))
                }
                return
            }
            

            do {
                let decodedObject = try self.decoder.decode(T.self, from: jsonData)
                DispatchQueue.main.sync {
                    completion(.success(decodedObject))
                }
            } catch let error {
                guard let apiError = self.checkForAPIError(using: jsonData) else {
                    DispatchQueue.main.sync {
                        print("Error finding API error, passing decode error")
                        completion(.error(.decoding(error)))
                    }
                    return
                }
                
                DispatchQueue.main.sync {
                    completion(.error(apiError))
                }
            }
        }.resume()
    }
    
    func checkForAPIError(using jsonData: Data) -> WeatherServiceError? {
        do {
            let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            
            if let code = dict?["cod"] as? String {
                if let message = dict?["message"] as? String {
                    return .apiError(message)
                }
                
                return .apiError("\(code) error")
            }
        } catch {
            print("Error parsing json data for API error")
            return nil
        }
        
        print("No data found pointing to API error, need additional debugging")
        return nil
    }
}


extension WeatherNetworkManager {
    
}
