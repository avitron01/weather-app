//
//  FavouriteWeatherLocationController.swift
//  Weather
//
//  Created by Avinash P on 26/03/21.
//

import UIKit

class FavouriteWeatherLocationController: BaseViewController {
    //MARK: - Outlet properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouritesLabel: UILabel!
    
    //MARK: - Private properties
    private let viewModel = FavouriteWeatherLocationViewModel()
    
    //MARK: - Computed property
    var shouldFavouritesList: Bool {
        return (self.viewModel.favoriteLocationsList.value?.count ?? 0) <= 0
    }
    
    //MARK: - View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.favoriteLocationsList.bind { (locations) in
            self.tableView.reloadData()
            self.hideFavouritesList(self.shouldFavouritesList)
        }
        
        self.viewModel.errorHandler.bind { (message) in
            if let message = message {
                self.showErrorAlert(with: message)
            }
        }
        
        self.viewModel.isLoading.bind { (isLoading) in
            isLoading ? self.showSpinner() : self.removeSpinner()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideFavouritesList(self.shouldFavouritesList)
    }
    
    //MARK: - Helper methods
    func hideFavouritesList(_ hide: Bool) {
        self.tableView.isHidden = hide
        self.favouritesLabel.isHidden = !hide
    }
        
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.parent?.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Table view datasource and delegates
extension FavouriteWeatherLocationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favourties"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoriteLocationsList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell" , for: indexPath)
        cell.textLabel?.text = self.viewModel.favoriteLocationsList.value?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.fetchWeatherData(for: indexPath.row, context: self)
    }
}
