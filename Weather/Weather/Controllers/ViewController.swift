//
//  ViewController.swift
//  Weather
//
//  Created by Avinash P on 23/03/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        WeatherService.fetchCurrentWeather(for: "London") { (result) in
            switch result {
            case .success(let weather):
                print("success")
            case .error(let error):
                print("Error \(error.localizedDescription)")
            }
        }
    }


}
