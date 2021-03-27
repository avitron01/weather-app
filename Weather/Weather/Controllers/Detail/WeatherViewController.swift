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
    @IBOutlet var labelCollection: [UILabel]!
        
    let cellConstants = TableCellConstants.WeatherViewController.self
    
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
        
        tableView.register(UINib(nibName: cellConstants.weatherDataNibName, bundle: nil), forCellReuseIdentifier: cellConstants.weatherData)
        
        updateLabelColors()
        addWeatherGradientLayer(isDayTime: self.viewModel.isDayTime)
    }

    func updateLabelColors() {
        for label in labelCollection {
            label.textColor = self.viewModel.isDayTime ? .black : .white
        }
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

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.otherWeatherData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellConstants.weatherData, for: indexPath) as! WeatherDataTableViewCell
        let weatherInfo = self.viewModel.otherWeatherData?[indexPath.row]
        cell.fieldLabel.text = weatherInfo?.field
        cell.valueLabel.text = weatherInfo?.value
        cell.labelColor = self.viewModel.isDayTime ? .black : .white
        
        return cell
    }
    
    
}
