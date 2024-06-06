//
//  PlanetView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 27/02/2024.
//

import Foundation
import UIKit

class PlanetView: UIView {
    
    let planetView = UIImageView()
    let planetLabel = UILabel()
    var planetXConstraint: NSLayoutConstraint!
    var planetYConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Create a UIImageView for the SF Symbol
        translatesAutoresizingMaskIntoConstraints = false
        // Configure the SF Symbol
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .thin)
        let symbolImage = UIImage(systemName: "globe.asia.australia.fill", withConfiguration: symbolConfiguration)
        planetView.image = symbolImage
        planetView.tintColor = K.tealBlue
        planetView.translatesAutoresizingMaskIntoConstraints = false
        
        planetLabel.text = String(localized: "defaultPlanet")
        planetLabel.font = UIFont.systemFont(ofSize: 14) // Example font size
        planetLabel.textColor = K.lightCream
        planetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UIImageView to the view
        addSubview(planetView)
        addSubview(planetLabel)
        
        planetXConstraint = planetView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -70)
        planetYConstraint = planetView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70)
        
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            planetXConstraint,
            planetYConstraint,
            planetLabel.centerXAnchor.constraint(equalTo: planetView.centerXAnchor),
            planetLabel.topAnchor.constraint(equalToSystemSpacingBelow: planetView.bottomAnchor, multiplier: 2),
        ])
    }
    
    func updatePlanetPosition(deltaAngels: [String: Double]) {
        let width = UIScreen.main.bounds.width
        let height =  UIScreen.main.bounds.height
        
        let xFactor = width / 40.0
        let yFactor = height / 20.0
        
        let x = xFactor * (deltaAngels[K.deltaAzimuthValueKey] ?? 0.0)
        let y = yFactor * (deltaAngels[K.deltaElevationValueKey] ?? 0.0)
        let pitchAngle = -(deltaAngels[K.pitchAngleValueKey] ?? 0.0)
        
        let xT = x * Darwin.cos(pitchAngle) - y * sin(pitchAngle)
        let yT = x * Darwin.sin(pitchAngle) + y * cos(pitchAngle)
                      
        planetXConstraint.constant = xT
        planetYConstraint.constant = -yT
    }
    
    func updatePlanetName(planetName: String) {
        planetLabel.text = planetName
    }
    
    func planetOnScreen() -> Bool {
        let width = UIScreen.main.bounds.width
        let height =  UIScreen.main.bounds.height

        let x = abs(planetXConstraint.constant)
        let y = abs(planetYConstraint.constant)
        
        if x < width / 2 && y < height / 2 {
            return true
        } else {
            return false
        }
    }
    
}
