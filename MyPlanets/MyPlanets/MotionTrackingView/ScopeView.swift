//
//  ScopeView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 18/02/2024.
//

import Foundation
import UIKit

class ScopeView: UIView {

    private let scope = UIImageView()
    private let arrow = UIImageView()
    //private let arrow = UIImageView(image: UIImage(systemName: "arrowshape.up"))
    
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
        backgroundColor = .yellow
        let scopeConfiguration = UIImage.SymbolConfiguration(pointSize: 96, weight: .ultraLight)
        let scopeImage = UIImage(systemName: "scope", withConfiguration: scopeConfiguration)
        scope.image = scopeImage
        scope.tintColor = UIColor.secondarySystemFill
        scope.translatesAutoresizingMaskIntoConstraints = false
        let arrowConfiguration = UIImage.SymbolConfiguration(pointSize: 72, weight: .ultraLight)
        let arrowImage = UIImage(systemName: "arrowshape.up", withConfiguration: arrowConfiguration)
        arrow.image = arrowImage
        arrow.tintColor = UIColor.systemRed.withAlphaComponent(0.3) // Adjust opacity here
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
              
        // Add the UIImageView to the view
        addSubview(scope)
        addSubview(arrow)
        
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            scope.centerXAnchor.constraint(equalTo: centerXAnchor),
            scope.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.centerXAnchor.constraint(equalTo: scope.centerXAnchor, constant: -70),
            arrow.centerYAnchor.constraint(equalTo: scope.centerYAnchor, constant: -70)
        ])
        
        // Start arrow rotation animation
//        arrow.layer.add(arrowRotationAnimation, forKey: "rotationAnimation")
        updateArrowDirection(to: CGPoint(x: 70, y: -70))
        
    }
    
    // Arrow rotation animation
    private var arrowRotationAnimation: CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.fromValue = 0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 2.0 // Adjust as needed for rotation speed
        animation.repeatCount = .infinity
        return animation
    }
    
    func updateArrowDirection(to point: CGPoint) {
        // Calculate angle between scope center and the point
        let angle = atan2(point.y - scope.center.y, point.x - scope.center.x)
        
        // Apply rotation to arrow
        arrow.transform = CGAffineTransform(rotationAngle: angle)
    }
}
