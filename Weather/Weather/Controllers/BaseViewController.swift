//
//  BaseViewController.swift
//  Weather
//
//  Created by Avinash P on 27/03/21.
//

import UIKit

protocol SpinnerViewControllerProtocol {
    var spinnerVC: SpinnerViewController { get set }
    
    func showSpinner()
    func removeSpinner()
}

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.quaternarySystemFill.withAlphaComponent(0.5)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
        
}

class BaseViewController: UIViewController, SpinnerViewControllerProtocol {
    var spinnerVC: SpinnerViewController = SpinnerViewController()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spinnerVC.view.frame = view.frame
    }
    
    func showSpinner() {
        self.spinnerVC = SpinnerViewController()
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
    }
    
    func removeSpinner() {
        spinnerVC.willMove(toParent: nil)
        spinnerVC.view.removeFromSuperview()
        spinnerVC.removeFromParent()
    }    
}
