//
//  PlanetTileView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//

import UIKit

class PlanetTileView: UIView {
    // Properties for planet details
    var planetImage: UIImage?
    var planetName: String = "Planeta"
    var planetDescription: String = "Short description"
    var buttonName: String = "Let's find planeta"
    
    // Button action closure for navigation
    var didSelectButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Set corner radius
        layer.cornerRadius = 10.0
        layer.masksToBounds = true 
        // Customize the appearance of the tile view (e.g., layout, background color, etc.)
        // Add UIImageView, UILabels, and UIButton for planet details
        backgroundColor = .systemBlue
        
        // Example: Add UILabels for planet name and description
        let nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = planetName
        nameLabel.textColor = .red
        addSubview(nameLabel)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: frame.width - 20, height: 60))
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = planetDescription
        descriptionLabel.numberOfLines = 0 // Allow multiple lines
        descriptionLabel.textColor = .red
        addSubview(descriptionLabel)

        // Example: Add UIImageView for planet image
        let imageView = UIImageView(frame: bounds)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = planetImage
        addSubview(imageView)
        
        // Example: Add UIButton for navigation
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 0, width: 302, height: 48)
        button.layer.backgroundColor = UIColor(red: 0.678, green: 0.204, blue: 0.243, alpha: 1).cgColor
        button.layer.cornerRadius = 6
        button.setTitle(buttonName, for: .normal)
        button.setTitle("Dupa TEST", for: .focused)
        button.addTarget(self, action: #selector(navigateToDetails), for: .touchUpInside)
        addSubview(button)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Image View
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalToConstant: 250), // Adjust height as needed
            
            // Button
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
//            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
            
        ])
    }
    
    @objc private func navigateToDetails() {
        print("bubu")
        didSelectButton?()
    }
}

