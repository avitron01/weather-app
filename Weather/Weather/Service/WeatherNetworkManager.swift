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
                let dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                print("\(dict)")
            } catch let error {
                print("\(error)")
            }
            
            
            do {
                let decodedObject = try self.decoder.decode(T.self, from: jsonData)
                DispatchQueue.main.sync {
                    completion(.success(decodedObject))
                }
            } catch let error {
                DispatchQueue.main.sync {
                    completion(.error(.decoding(error)))
                }
            }
        }.resume()
    }
}

extension WeatherNetworkManager {
    
}
