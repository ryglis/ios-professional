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
    private let desiredImageHeight: CGFloat = 100.0 // Adjust image height as needed

    var imageView: UIImageView
    
    var nameLabel: UILabel
    var descriptionLabel: UILabel
    var button: UIButton
    var coverView = UIView()

    
    // Button action closure for navigation
    var delegate: PlanetTileViewDelegate?
    
    override init(frame: CGRect) {
        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: frame.width - 20, height: 60))
        button = UIButton(configuration: .filled())
        imageView = UIImageView()
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Set corner radius
        layer.cornerRadius = 40.0
        layer.masksToBounds = true 
        // Customize the appearance of the tile view (e.g., layout, background color, etc.)
        // Add UIImageView, UILabels, and UIButton for planet details
        backgroundColor = K.lightbackground
        
        // Example: Add UILabels for planet name and description
//        nameLabel = UILabel(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 20))
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = ""
        nameLabel.textColor = K.lightCream
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        addSubview(nameLabel)
        
//        descriptionLabel = UILabel(frame: CGRect(x: 10, y: 40, width: frame.width - 20, height: 60))
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 0 // Allow multiple lines
        descriptionLabel.font = UIFont.systemFont(ofSize: 14.0)
        descriptionLabel.textColor = K.lightCream
        addSubview(descriptionLabel)

        // Example: Add UIImageView for planet image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: desiredImageHeight)
        imageView.image = UIImage()
        addSubview(imageView)
        
//        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        coverView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: desiredImageHeight)
//        addSubview(coverView)
        
        // Example: Add UIButton for navigation
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.frame = CGRect(x: 0, y: 0, width: 302, height: 48)
        button.backgroundColor = K.tealBlue
        button.layer.cornerRadius = 20
        button.setTitleColor(K.lightCream, for: .normal)
        button.setTitle(String(localized: "searchButtonName"), for: .normal)
        button.addTarget(self, action: #selector(navigateToDetails), for: .touchUpInside)
      
        button.configuration?.cornerStyle = .capsule  // set corner style on existing config
        addSubview(button)
        
      
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            
            // Image View
//            imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
//            imageView.heightAnchor.constraint(equalToConstant: (imageView.image?.size.width ?? 0.0)/UIScreen.main.bounds.width*(imageView.image?.size.height ?? 1.0)),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),

 //           imageView.heightAnchor.constraint(equalToConstant: desiredImageHeight),

//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            imageView.heightAnchor.constraint(equalToConstant: 150), // Adjust height as needed
            
            
//            coverView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
//            coverView.centerXAnchor.constraint(equalTo: centerXAnchor),
//            
            
            
            
            
            
            
            
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            
            // Description Label
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Image View
//            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
//            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
////            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
////            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            imageView.heightAnchor.constraint(equalToConstant: 250), // Adjust height as needed
            
            // Button
            button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
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

