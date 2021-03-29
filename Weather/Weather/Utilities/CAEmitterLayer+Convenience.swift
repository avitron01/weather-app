//
//  CAEmitterLayer+Convenience.swift
//  Weather
//
//  Created by Avinash P on 28/03/21.
//

import Foundation
import UIKit

protocol WeatherParticleEmitterProtocol {
    static var cloudCell: CAEmitterCell { get }
    static var starCell: CAEmitterCell { get }
    static func weatherParticleEmitter() -> CAEmitterLayer
    static func emitterCells(for isDayTime: Bool) -> [CAEmitterCell]
}

extension CAEmitterLayer: WeatherParticleEmitterProtocol {
    static func weatherParticleEmitter() -> CAEmitterLayer {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = .zero
        particleEmitter.emitterSize = .zero
        particleEmitter.emitterShape = .circle
        return particleEmitter
    }
    
    static func emitterCells(for isDayTime: Bool) -> [CAEmitterCell]  {
        if isDayTime {
            return [cloudCell]
        } else {
            return [starCell, cloudCell]
        }
    }
    
    static var cloudCell: CAEmitterCell {
        let imageName = "cloud.fill"
        let cell = CAEmitterCell()
        cell.birthRate = Float.random(in: 0.1...0.3)
        cell.lifetime = 25.0
        cell.lifetimeRange = 0
        cell.velocity = 60
        cell.velocityRange = 20
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 15
        cell.scale = 1.5
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        
        cell.contents = UIImage(systemName: imageName)?.cgImage
        return cell
    }
    
    static var starCell: CAEmitterCell {
        let imageName = "star.fill"
        let cell = CAEmitterCell()
        cell.birthRate = Float.random(in: 0.05...0.1)
        cell.lifetime = 30.0
        cell.lifetimeRange = 0
        cell.velocity = 20
        cell.velocityRange = 10
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 16
        cell.scale = 0.5        
        cell.contents = UIImage(systemName: imageName)?.cgImage
        return cell
    }
}
