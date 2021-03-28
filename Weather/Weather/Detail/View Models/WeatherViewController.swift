//
//  WeatherViewController.swift
//  Weather
//
//  Created by Avinash P on 23/03/21.
//

import UIKit

class WeatherViewController: BaseViewController {
    //MARK: - Outlet properties
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLocation: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherPrimaryInfoStackView: UIStackView!
    @IBOutlet var labelCollection: [UILabel]!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: - Stored properties
    let cellConstants = TableCellConstants.WeatherViewController.self
    let viewModel: WeatherViewModel
    var firstTimeLayoutUpdate = true
    
    //MARK: - Lazy properties
    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect.zero
        return gradientLayer
    }()
    
    lazy var particleEmitter: CAEmitterLayer = {
        return CAEmitterLayer.weatherParticleEmitter()
    }()

    //MARK: - Computed properties
    var emitterCoordinates: CGRect {
        let x = self.view.frame.maxX
        let y = (self.view.frame.midY / 2.0)
        let width: CGFloat = 10.0
        let height: CGFloat = 10.0
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    var gradientFrame: CGRect {
        let width = self.view.bounds.width * 3
        let x = -(width - self.view.bounds.width)
        let y = self.view.bounds.minY
        return CGRect(x: x, y: y, width: width, height: self.view.bounds.height)
    }
    
    //MARK: - Initializers
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - View controller life cycle
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
        self.addWeatherGradientLayer()
        self.addWeatherParticles()
        self.updateCloseButtonStyle()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTimeLayoutUpdate {
            firstTimeLayoutUpdate.toggle()
            self.updateLayers()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.updateLayers()
        }, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.gradientLayer.removeAllAnimations()
        self.gradientLayer.removeFromSuperlayer()
        self.particleEmitter.removeFromSuperlayer()
    }
    
    //MARK: - Outlet actions
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        self.viewModel.toggleIsFavourite()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UI config methods
    func registerTableCellNibs() {
        tableView.register(UINib(nibName: cellConstants.weatherDataNibName, bundle: nil), forCellReuseIdentifier: cellConstants.weatherData)
    }
        
    func updateLayers() {
        self.gradientLayer.frame = self.gradientFrame
        self.particleEmitter.emitterPosition = self.emitterCoordinates.origin
        self.gradientLayer.removeAllAnimations()
        self.addGradientAnimation()
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

    func updateCloseButtonStyle() {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .ultraLight, scale: .medium)
        let image = UIImage(systemName: "xmark.circle.fill", withConfiguration: config)
        self.closeButton.setImage(image, for: .normal)
    }
    
    func addWeatherGradientLayer() {
        self.gradientLayer.colors = self.viewModel.weatherGradientColors
        self.backgroundView.layer.addSublayer(gradientLayer)
    }
    
    func addGradientAnimation() {
        let animationKey: String = "gradientAnimation"
        
        guard let animationKeys = gradientLayer.animationKeys(), animationKeys.contains(animationKey) else {
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 7.0
            animation.fromValue = self.gradientFrame.width - (self.gradientFrame.width / 3)
            animation.toValue = self.gradientFrame.maxX - (self.gradientFrame.width / 3)
            animation.autoreverses = true
            animation.repeatCount = Float.infinity
            self.gradientLayer.add(animation, forKey: animationKey)
            return
        }
    }
    
    func addWeatherParticles() {
        self.particleEmitter.emitterPosition = self.emitterCoordinates.origin
        self.particleEmitter.emitterSize = self.emitterCoordinates.size
        self.particleEmitter.emitterCells = CAEmitterLayer.emitterCells(for: self.viewModel.isDayTime)
        self.backgroundView.layer.addSublayer(self.particleEmitter)
    }
}

//MARK: - Table view delegates and data source
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
