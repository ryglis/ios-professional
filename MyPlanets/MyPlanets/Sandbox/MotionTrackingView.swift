//
//  MotionValuesViewRAWAI.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 31/01/2024.
//

import UIKit
import Foundation
import CoreMotion
import CoreLocation

class MotionTrackingView: UIView {

    var motionStackView = UIStackView()
    var labels: [(String, UILabel)] = []
    var currentOrientationString: String {
        switch UIDevice.current.orientation {
        case .portrait:
            return "Portrait"
        case .portraitUpsideDown:
            return "PortraitUpsideDown"
        case .landscapeLeft:
            return "LandscapeLeft"
        case .landscapeRight:
            return "LandscapeRight"
        case .faceUp:
            return "FaceUp"
        case .faceDown:
            return "FaceDown"
        case .unknown:
            return "Unknown"
        @unknown default:
            return "Unknown"
        }
    }
    

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
        motionStackView.backgroundColor = .clear
//        motionStackView.backgroundColor = K.backbgroundcolor
        

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
//            (K.rollLabelKey, makeLabel(text: String(localized: "rollLabel"))),
            (K.rollLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.rollLabelKey)))),
            (K.pitchLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.pitchLabelKey)))),
            (K.yawLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.yawLabelKey)))),
            (K.elevationLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.elevationLabelKey)))),
            (K.azimuthLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.azimuthLabelKey)))),
            (K.planetElevationLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.planetElevationLabelKey)))),
            (K.planetAzimuthLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.planetAzimuthLabelKey)))),
            (K.headingLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.headingLabelKey)))),
            (K.orientationLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.orientationLabelKey)))),
            (K.latitudeLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.latitudeLabelKey)))),
            (K.longitudeLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.longitudeLabelKey)))),
        ]
    }
    
    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textColor = K.lightCream.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func updateLabel(updatedLabel: (String, Double)) {
        for label in labels {
            if label.0 == updatedLabel.0 {
                let labelLocalKey = String.LocalizationValue(label.0)
                let labelLocalValue = String(localized: labelLocalKey)
                label.1.text = String(format: "\(labelLocalValue): %.2f", updatedLabel.1)
            }
        }
    }
    
    func updateOrientationLabel(updatedLabel: String) {
        for label in labels {
            if label.0 == updatedLabel {
                let labelLocalKey = String.LocalizationValue(label.0)
                let labelLocalValue = String(localized: labelLocalKey)
                let currentOrientation = currentOrientationString
                label.1.text = "\(labelLocalValue): \(currentOrientation)"
            }
        }
    }
    
}

