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
        print("motionStackView VIEW HEIGHT = \(motionStackView.frame.height)")
        print("motionStackView VIEW WIDTH = \(motionStackView.frame.width)")
        print("motionStackView VIEW CENTER = \(motionStackView.center)")
    }

    private func createLabels() {
        labels = [
            ("roll", makeLabel(text: "Roll: ")),
            ("pitch", makeLabel(text: "Pitch: ")),
            ("yaw", makeLabel(text: "Yaw: ")),
            ("elevation", makeLabel(text: "Elevation: ")),
            ("azimuth", makeLabel(text: "Azimuth: ")),
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
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
}

