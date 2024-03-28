//
//  PlanetDataView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 28/03/2024.
//


import UIKit
import Foundation

class TrackingDataView: UIView {

    var trackingDataStackView = UIStackView()
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
        
        trackingDataStackView.axis = .vertical
        trackingDataStackView.alignment = .leading
        trackingDataStackView.distribution = .fill
        trackingDataStackView.spacing = 8
        trackingDataStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(trackingDataStackView)
        for label in labels {
            trackingDataStackView.addArrangedSubview(label.1)
        }
        trackingDataStackView.backgroundColor = .clear
//        motionStackView.backgroundColor = K.backbgroundcolor
        

        NSLayoutConstraint.activate([
            // Motion stack view constraints
            trackingDataStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            trackingDataStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            trackingDataStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            trackingDataStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }

    private func createLabels() {
        labels = [
            //phone data
            (K.elevationLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.elevationLabelKey)))),
            (K.azimuthLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.azimuthLabelKey)))),
            //planet data
            (K.planetElevationLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.planetElevationLabelKey)))),
            (K.planetAzimuthLabelKey, makeLabel(text: String(localized: String.LocalizationValue(K.planetAzimuthLabelKey)))),
            //localisation data
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
    
}

