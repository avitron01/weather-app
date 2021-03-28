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
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    
    let cellConstants = TableCellConstants.WeatherViewController.self
    let viewModel: WeatherViewModel
    var gradientView: CAGradientLayer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableCellNibs()
                
        self.weatherImage.image = self.viewModel.weatherImage
        self.weatherLocation.text = self.viewModel.weatherLocation
        self.weatherTemperature.text = self.viewModel.weatherTemperature
        self.weatherDescription.text = self.viewModel.weatherDescription
        
        self.viewModel.isFavourite.bind { (isFavourite) in
            self.updateFavouriteButton(isFavourite)
        }

        self.updateLabelColors()
        self.addWeatherGradientLayer(isDayTime: self.viewModel.isDayTime)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addGradientAnimation()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds = self.view.bounds
        self.gradientView?.frame = CGRect(x: -5, y: 0, width: bounds.width * 2, height: bounds.height)
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        self.viewModel.toggleIsFavourite()
    }
    
    func registerTableCellNibs() {
        tableView.register(UINib(nibName: cellConstants.weatherDataNibName, bundle: nil), forCellReuseIdentifier: cellConstants.weatherData)
    }
    
    func updateFavouriteButton(_ isFavourite: Bool) {
        var image: UIImage?
        var tintColor: UIColor?
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .ultraLight, scale: .medium)
        if isFavourite {
            image = UIImage(systemName: "heart.fill", withConfiguration: config)
            tintColor = .systemPink
        } else {
            tintColor = self.viewModel.isDayTime ? .black : .white
            image = UIImage(systemName: "heart", withConfiguration: config)
        }
        
        self.favouriteButton.tintColor = tintColor
        self.favouriteButton.setImage(image, for: .normal)
    }
    
    func updateLabelColors() {
        for label in labelCollection {
            label.textColor = self.viewModel.isDayTime ? .black : .white
        }
    }

    func addWeatherGradientLayer(isDayTime: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = self.viewModel.weatherGradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect.zero
                
        self.backgroundView.layer.addSublayer(gradientLayer)
        let bounds = self.view.bounds
        gradientLayer.frame = CGRect(x: -bounds.width * 2, y: 0, width: bounds.width * 2, height: bounds.height)
        self.gradientView = gradientLayer
    }
    
    func addGradientAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
//        animation.duration = 5.0
        animation.fromValue = -self.view.bounds.width
        animation.toValue = 0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        self.gradientView?.add(animation, forKey: "gradientAnimation")
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
