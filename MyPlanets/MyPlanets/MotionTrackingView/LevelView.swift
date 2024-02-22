//
//  LevelView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 18/02/2024.
//

import Foundation
import UIKit

class LevelView: UIView {
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
        backgroundColor = .cyan
        let levelView = UIImageView()
        let errorMessageLabel = UILabel()
        
        // Configure the SF Symbol
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let symbolImage = UIImage(systemName: "circle.and.line.horizontal", withConfiguration: symbolConfiguration)
        levelView.image = symbolImage
        levelView.tintColor = .red
        levelView.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0 //zero oznacza że jeśli przekorszy rozmiar linii, to rozszerzy się na kolejną linię, aż do skutku
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = "Turn your phone sideways"
        
        // Add the UIImageView to the view
        addSubview(levelView)
        addSubview(errorMessageLabel)
        
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            // Motion stack view constraints
            levelView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            levelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            levelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            levelView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: levelView.bottomAnchor, multiplier: 2),
            //errorMessageLabel.leadingAnchor.constraint(equalTo: levelView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: levelView.trailingAnchor)
        ])
    }
}
