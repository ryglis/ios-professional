//
//  LevelErrorView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 22/02/2024.
//

import Foundation
import UIKit

class LevelErrorView: UIView {
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
        layer.cornerRadius = 10 // Adjust the corner radius as needed
        clipsToBounds = true // Ensures that the content inside the view doesn't overflow the rounded corners
        backgroundColor = .secondarySystemBackground
        
        let errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.font = UIFont.boldSystemFont(ofSize: 24.0) // Adjust the font size as needed
        errorMessageLabel.numberOfLines = 0 //zero oznacza że jeśli przekorszy rozmiar linii, to rozszerzy się na kolejną linię, aż do skutku
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = "Turn your phone sideways"
        
        // Add the UIImageView to the view
        addSubview(errorMessageLabel)
        
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            // Motion stack view constraints
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorMessageLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: errorMessageLabel.trailingAnchor
                                      , multiplier: 2),
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 4),
            bottomAnchor.constraint(equalToSystemSpacingBelow: errorMessageLabel.bottomAnchor, multiplier: 4),
        ])
    }
}

