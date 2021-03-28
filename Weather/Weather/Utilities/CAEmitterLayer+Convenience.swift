//
//  CAEmitterLayer+Convenience.swift
//  Weather
//
//  Created by Avinash P on 28/03/21.
//

import Foundation
import UIKit

protocol WeatherParticleEmitterProtocol {
    static func weatherParticleEmitter() -> CAEmitterLayer
    static func makeEmitterCell(for imageName: String) -> CAEmitterCell
}

extension CAEmitterLayer: WeatherParticleEmitterProtocol {
    static func weatherParticleEmitter() -> CAEmitterLayer {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterPosition = .zero
        particleEmitter.emitterSize = .zero
        particleEmitter.emitterShape = .circle
        return particleEmitter
    }
    
    static func emitterCells(for isDayTime: Bool) -> [CAEmitterCell] {
        if isDayTime {
            let clouds = makeEmitterCell(for: "cloud.fill")
            return [clouds]
        } else {
            let stars = makeEmitterCell(for: "star.fill")
            return [stars]
        }
    }
    
    static func makeEmitterCell(for imageName: String) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 1
        cell.lifetime = 10.0
        cell.lifetimeRange = 0
        cell.velocity = 100
        cell.velocityRange = 100
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05

        cell.contents = UIImage(systemName: imageName)?.cgImage
        return cell
    }
}
