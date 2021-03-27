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
    
    private let viewModel = WeatherLocationSearchViewModel()
    private var shouldHideRecentsList: Bool {
        return viewModel.recentlySearched.value.count <= 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.recentlySearched.bind { (weatherData) in
            self.tableView.reloadData()
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
        return "Recently Searched"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.recentlySearched.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recents", for: indexPath)
        cell.textLabel?.text = self.viewModel.recentlySearched.value[indexPath.row].name
        return cell
    }
    
}

extension WeatherLocationSearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = searchBar.text, !searchString.isEmpty {
            viewModel.fetchWeatherData(for: searchString)
        }
    }
}
