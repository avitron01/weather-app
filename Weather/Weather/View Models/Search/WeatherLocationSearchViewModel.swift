//
//  WeatherLocationSearchViewModel.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation
import UIKit.UIViewController

class WeatherLocationSearchViewModel {    
    var isLoading = Box(false)
    var errorHandler: Box<String?> = Box(nil)
    
    let database: DatabaseManager = {
        return DatabaseManager.shared
    }()
    
    var recentlySearched: Box<[WeatherData]> = {
        return Box(DatabaseManager.shared.recentlySearchedLocations())
    }()
    
    func fetchWeatherData(for location: String, context: UIViewController) {
        self.isLoading.value = true
        WeatherService.fetchCurrentWeather(for: location) { (result) in
            switch result {
            case .success(let weatherData):
                self.updateRecentlySearched()
                self.presentWeatherDetailViewController(with: weatherData, context: context)                
            case .error(let error):
                self.handleFetchError(error)
            }
            self.isLoading.value = false
        }
    }

    func handleFetchError(_ error: WeatherServiceError) {
        switch error {
        case .parseError, .urlCreationError, .decoding(_), .network(_), .noDataFound:
            self.errorHandler.value = "Error fetching weather data"
        case .networkUnavailable:
            self.errorHandler.value = "Internet Unavailable"
        case .apiError(let error):
            self.errorHandler.value = error.description
        }
    }
    
    func updateRecentlySearched() {
        self.recentlySearched.value = self.database.recentlySearchedLocations()
    }
    
    func presentWeatherDetailViewController(with item: WeatherData, context: UIViewController) {
        let viewModel = WeatherViewModel(weatherData: item)
        let viewController = WeatherViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        context.present(viewController, animated: true, completion: nil)
    }
}
