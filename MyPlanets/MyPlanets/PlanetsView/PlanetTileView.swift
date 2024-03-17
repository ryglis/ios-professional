//
//  PlanetTileView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//

import UIKit

protocol PlanetTileViewDelegate: AnyObject {
  func didSelectTileView(_ tileView: PlanetTileView)
}

class PlanetTileView: UIView {
    // Properties for planet details
    var imageView: UIImageView
    
    var nameLabel: UILabel
    var descriptionLabel: UILabel
    var button: UIButton
    
    // Button action closure for navigation
    var delegate: PlanetTileViewDelegate?
    
    override init(frame: CGRect) {
        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: frame.width - 20, height: 60))
        button = UIButton(type: .custom)
        imageView = UIImageView()
        
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
        backgroundColor = K.lightbackground
        
        // Example: Add UILabels for planet name and description
        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = ""
        nameLabel.textColor = K.lightCream
        addSubview(nameLabel)
        
        descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: frame.width - 20, height: 60))
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 0 // Allow multiple lines
        descriptionLabel.textColor = K.lightCream
        addSubview(descriptionLabel)

        // Example: Add UIImageView for planet image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
//        imageView.image = UIImage(named: <#T##String#>)
        addSubview(imageView)
        
        // Example: Add UIButton for navigation
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.frame = CGRect(x: 0, y: 0, width: 302, height: 48)
        button.backgroundColor = K.tealBlue
        button.layer.cornerRadius = 6
        button.setTitleColor(K.lightCream, for: .normal)
        button.setTitle(String(localized: "searchButtonName"), for: .normal)
        button.addTarget(self, action: #selector(navigateToDetails), for: .touchUpInside)
        // Set the content padding to add margin
        let inset: CGFloat = 10
        // Create a configuration object
        var buttonConfig = UIButton.Configuration.tinted()
        buttonConfig.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        button.configuration = buttonConfig
        addSubview(button)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
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
//        print("bubu")
        delegate?.didSelectTileView(self) // Call delegate method
    }
}

