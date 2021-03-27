//
//  WeatherLocationSearchController.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import UIKit

//MARK: - TODO: Handle error cases

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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let shouldHideRecents = self.shouldHideRecentsList
        self.tableView.isHidden = shouldHideRecents
        self.searchLabel.isHidden = !shouldHideRecents
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
        let viewModel = WeatherViewModel(weatherData: item)
        let viewController = WeatherViewController(viewModel: viewModel)
        self.present(viewController, animated: true, completion: nil)        
    }
}

extension WeatherLocationSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.isEmpty {
            viewModel.fetchWeatherData(for: searchString)
        }
    }
}
