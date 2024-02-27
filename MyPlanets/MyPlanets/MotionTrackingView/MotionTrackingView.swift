//
//  MotionValuesViewRAWAI.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 31/01/2024.
//

import UIKit
import CoreMotion
import CoreLocation

class MotionTrackingView: UIView {

    var motionStackView = UIStackView()
    var labels: [(String, UILabel)] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemneted")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .orange
        createLabels()
        
        motionStackView.axis = .vertical
        motionStackView.alignment = .leading
        motionStackView.distribution = .fill
        motionStackView.spacing = 8
        motionStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(motionStackView)
        for label in labels {
            motionStackView.addArrangedSubview(label.1)
        }
        motionStackView.backgroundColor = .systemBackground

        NSLayoutConstraint.activate([
            // Motion stack view constraints
            motionStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            motionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            motionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            motionStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

    private func createLabels() {
        labels = [
            ("roll", makeLabel(text: "Roll: ")),
            ("pitch", makeLabel(text: "Pitch: ")),
            ("yaw", makeLabel(text: "Yaw: ")),
            ("elevation", makeLabel(text: "Elevation: ")),
            ("azimuth", makeLabel(text: "Azimuth: ")),
            ("planet Ele", makeLabel(text: "Planet Ele: ")),
            ("planet Azi", makeLabel(text: "Planet Azi: ")),
//            ("w", makeLabel(text: "w: ")),
//            ("x", makeLabel(text: "x: ")),
//            ("y", makeLabel(text: "y: ")),
//            ("z", makeLabel(text: "z: ")),
//            ("theta", makeLabel(text: "theta: ")),
//            ("thetaDeg", makeLabel(text: "thetaDeg: ")),
//            ("q", makeLabel(text: "q: ")),
            ("heading", makeLabel(text: "Heading: ")),
          //  ("orientation", makeLabel(text: "Orientation: ")),
        ]
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .label.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func updateLabel(updatedLabel: (String, Double)) {
        for label in labels {
            if label.0 == updatedLabel.0 {
                label.1.text = String(format: "\(updatedLabel.0.capitalized): %.2f", updatedLabel.1)
            }
        }
    }
    
}

