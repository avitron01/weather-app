//
//  FavouriteWeatherLocationViewModel.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import Foundation
import RealmSwift
import UIKit.UIViewController

class FavouriteWeatherLocationViewModel {
    var isLoading = Box(false)
    var notificationToken: NotificationToken?
    var favoriteLocationsList: Box<[String]?> = Box([])
    private var allFavouriteLocation: [RealmFavouriteWeatherLocation]?
    var errorHandler: Box<String?> = Box(nil)
    
    private var database: DatabaseManager = {
        return DatabaseManager.shared
    }()
    
    init() {
        self.notificationToken = database.addObserver(for: RealmFavouriteWeatherLocation.self, observer: { [weak self] (changes) in
            switch changes {
            case .initial(_):
                break
            case .update(_, deletions: _, insertions:_, modifications:_):
                self?.allFavouriteLocation = self?.database.fetchAllFavouriteWeatherLocation()
                self?.updateLocationList()
            case .error(_):
                break
            }
        })
        
        self.allFavouriteLocation = self.database.fetchAllFavouriteWeatherLocation()
        updateLocationList()
    }
    
    func updateLocationList() {
        self.favoriteLocationsList.value = self.allFavouriteLocation?.map {
            $0.name
        }
    }
    
    func fetchWeatherData(for index: Int, context: UIViewController) {
        guard let id = self.allFavouriteLocation?[index].id else {
            return
        }
        
        self.isLoading.value = true
        
        WeatherService.fetchWeather(using: "\(id)") { (result) in
            switch result {
            case .success(let weatherData):
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
    
    func presentWeatherDetailViewController(with item: WeatherData, context: UIViewController) {
        let viewModel = WeatherViewModel(weatherData: item)
        let viewController = WeatherViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        context.present(viewController, animated: true, completion: nil)
    }
}
