//
//  LevelView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 18/02/2024.
//

import Foundation
import UIKit

class LevelView: UIView {
    
    let levelView = UIImageView()
    let levelLabel = UILabel()
    
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
        let symbolImage = UIImage(systemName: "circle.and.line.horizontal", withConfiguration: symbolConfiguration)
        levelView.image = symbolImage
        levelView.tintColor = .systemRed
        levelView.translatesAutoresizingMaskIntoConstraints = false
        
        levelLabel.text = String(localized: "keepLevel")
        levelLabel.font = UIFont.systemFont(ofSize: 14) // Example font size
        levelLabel.textColor = UIColor.systemRed
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the UIImageView to the view
        addSubview(levelView)
        addSubview(levelLabel)
        
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            // Motion stack view constraints
            levelLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            levelLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            levelView.topAnchor.constraint(equalToSystemSpacingBelow: levelLabel.topAnchor, multiplier: 3),
//            levelView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: levelLabel.trailingAnchor, multiplier: 2),
//            trailingAnchor.constraint(equalToSystemSpacingAfter: levelView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: levelView.bottomAnchor, multiplier: 2),
            levelView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func updateLevelBasedOnMotion(angle: Double) {
        levelView.transform = CGAffineTransform.init(rotationAngle: (angle))
        let angleDeg = abs(angle) * K.radToDeg
        if angleDeg < 20 {
            levelView.tintColor = K.tealBlue.withAlphaComponent(0.5)
            levelLabel.textColor = K.lightCream.withAlphaComponent(0.5)
        } else {
            levelView.tintColor = .systemRed
            levelLabel.textColor = .systemRed
        }
    }
}
