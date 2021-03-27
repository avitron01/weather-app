//
//  WeatherViewController.swift
//  Weather
//
//  Created by Avinash P on 23/03/21.
//

import UIKit

class WeatherViewController: BaseViewController {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLocation: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var weatherPrimaryInfoStackView: UIStackView!
    
    
    
    let viewModel: WeatherViewModel
    var gradientView: CAGradientLayer?
    @IBOutlet weak var tableView: UITableView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.weatherImage.image = self.viewModel.weatherImage
        self.weatherLocation.text = self.viewModel.weatherLocation
        self.weatherTemperature.text = self.viewModel.weatherTemperature
        self.weatherDescription.text = self.viewModel.weatherDescription
        
        addWeatherGradientLayer(isDayTime: self.viewModel.isDayTime)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradientView?.frame = self.view.bounds
    }

    func addWeatherGradientLayer(isDayTime: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = self.viewModel.weatherGradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect.zero
                
        self.view.layer.insertSublayer(gradientLayer, below: self.weatherPrimaryInfoStackView.layer)
        gradientLayer.frame = self.view.bounds
        
        self.gradientView = gradientLayer
    }
}

