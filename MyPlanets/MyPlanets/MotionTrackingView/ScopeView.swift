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
    let radius = 100.0
    //private let arrow = UIImageView(image: UIImage(systemName: "arrowshape.up"))
    var arrowXConstraint: NSLayoutConstraint!
    var arrowYConstraint: NSLayoutConstraint!
    let labelX = UILabel()
    let labelY = UILabel()
    let labelAngle = UILabel()
    
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
        let scopeConfiguration = UIImage.SymbolConfiguration(pointSize: 96, weight: .ultraLight)
        let scopeImage = UIImage(systemName: "scope", withConfiguration: scopeConfiguration)
        scope.image = scopeImage
        scope.tintColor = UIColor.systemIndigo
        scope.translatesAutoresizingMaskIntoConstraints = false
        let arrowConfiguration = UIImage.SymbolConfiguration(pointSize: 72, weight: .ultraLight)
        let arrowImage = UIImage(systemName: "arrowshape.up", withConfiguration: arrowConfiguration)
        arrow.image = arrowImage
        arrow.tintColor = UIColor.systemIndigo.withAlphaComponent(0.3) // Adjust opacity here
        arrow.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        labelX.text = "Label 1"
        labelY.text = "Label 2"
        labelAngle.text = "Label 3"
        // Add labels to the stack view
        stackView.addArrangedSubview(labelX)
        stackView.addArrangedSubview(labelY)
        stackView.addArrangedSubview(labelAngle)
        
        // Add stack view to the main view
        addSubview(stackView)
              
        // Add the UIImageView to the view
        addSubview(scope)
        addSubview(arrow)
        
        arrowXConstraint = arrow.centerXAnchor.constraint(equalTo: scope.centerXAnchor, constant: -70)
        arrowYConstraint = arrow.centerYAnchor.constraint(equalTo: scope.centerYAnchor, constant: -70)
        // Add constraints to position the symbol in the bottom right corner
        NSLayoutConstraint.activate([
            scope.centerXAnchor.constraint(equalTo: centerXAnchor),
            scope.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowXConstraint,
            arrowYConstraint,
        ])
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 250),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
    
    private func updateArrowDirection(to point: CGPoint) {
        // Calculate angle between scope center and the point
        //TODO: FIX ANGLES
        //TODO: Przy headingu 360 gwałtowna zmiana Azymutu!!!
        let angle = atan2(point.x, -point.y)
        
        labelX.text = String(format: "X: %.2f", point.x)
        labelY.text = String(format: "Y: %.2f", point.y)
        // Apply rotation to arrow
        arrow.transform = CGAffineTransform(rotationAngle: angle)
        let angelDeg = angle * K.radToDeg
        labelAngle.text = String(format: "Ang: %.2f", angelDeg)
        
    }
    
    func updateArrow(deltaAngels: [String: Double]) {
        var x = deltaAngels["deltaAzimuth"] ?? 0.0
        var y = deltaAngels["deltaElevation"] ?? 0.0
        let r = sqrt(x * x + y * y)
        x = x * radius / r
        y = y * radius / r
        arrowXConstraint.constant = x
        arrowYConstraint.constant = -y
        updateArrowDirection(to: CGPoint(x: x, y: -y))
    }
}
