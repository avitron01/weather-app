//
//  WeatherLocationSearchController.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import UIKit

class WeatherLocationSearchController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let stringConstants = StringConstants.WeatherLocationSearchController.self
    private let cellConstants = TableCellConstants.WeatherLocationSearchController.self
    
    private let viewModel = WeatherLocationSearchViewModel()
    private var shouldHideRecentsList: Bool {
        return viewModel.recentlySearched.value.count <= 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.recentlySearched.bind { (weatherData) in
            self.tableView.reloadData()
        }
                
        self.viewModel.isLoading.bind { (isLoading) in
            isLoading ? self.showSpinner() : self.removeSpinner()
            self.hideRecentsList(self.shouldHideRecentsList)
        }
        
        self.viewModel.errorHandler.bind { (message) in
            if let message = message {
                self.showErrorAlert(with: message)
            }
        }
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.parent?.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.updateRecentlySearched()
        self.hideRecentsList(self.shouldHideRecentsList)
    }
    
    func hideRecentsList(_ hide: Bool) {
        self.tableView.isHidden = hide
        self.searchLabel.isHidden = !hide
    }
}

extension WeatherLocationSearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return stringConstants.recentlySearched
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.recentlySearched.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.recents, for: indexPath)
        cell.textLabel?.text = self.viewModel.recentlySearched.value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.viewModel.recentlySearched.value[indexPath.row]
        viewModel.fetchWeatherData(for: item.name, context: self)
        dismisKeyboard()
    }
}

extension WeatherLocationSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.isEmpty {
            viewModel.fetchWeatherData(for: searchString, context: self)
            clearSearchBar()
            dismisKeyboard()
        }
    }
    
    func clearSearchBar() {
        self.searchBar.text = nil
    }
    
    func dismisKeyboard() {
        self.searchBar.endEditing(true)
    }
}
