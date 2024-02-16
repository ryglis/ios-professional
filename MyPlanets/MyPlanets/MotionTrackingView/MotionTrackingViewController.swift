//
//  NightSkyViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 31/01/2024.
//

import UIKit
import CoreMotion
import CoreLocation

class MotionTrackingViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    var mView: MotionTrackingView!
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMotionManager()
        setupLocationManager()
        // Listen for device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func setupView() {
        mView = MotionTrackingView()
        mView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mView)
        
        initializePortraitConstraints()
        initializeLandscapeConstraints()
        updateConstraintsForCurrentOrientation()
    }
    
    private func initializePortraitConstraints(){
        let topAnchor = mView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        let centerAnchor = mView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        portraitConstraints.append(contentsOf: [topAnchor, centerAnchor])
    }
    
    private func initializeLandscapeConstraints(){
        let leftAnchor = mView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2)
        let centerAnchor = mView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        landscapeConstraints.append(contentsOf: [leftAnchor, centerAnchor])
    }
    
    private func setupMotionManager() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.showsDeviceMovementDisplay = true
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical ,to: .main) { [weak self] (data, error) in
                guard let attitude = data?.attitude else { return }
                self?.updateMotionLabels(attitude)
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    private func updateMotionLabels(_ attitude: CMAttitude) {
        let radToDeg = 180.0 / .pi
        
        let roll = attitude.roll * radToDeg
        let pitch = attitude.pitch * radToDeg
        let yaw = attitude.yaw * radToDeg
        
        let quaternion = attitude.quaternion
        let w = quaternion.w
        let x = quaternion.x
        let y = quaternion.y
        let z = quaternion.z
        let theta = 2 * acos(w)
        let thetaDeg = theta * radToDeg
        let magnitude = sqrt(w * w + x * x + y * y + z * z)
        
        let updatedLabelValues = [
            ("roll", roll),
            ("pitch", pitch),
            ("yaw", yaw),
            ("w", w),
            ("x", x),
            ("y", y),
            ("z", z),
            ("theta", theta),
            ("thetaDeg", thetaDeg),
            ("q", magnitude),
        ]
        
        for updatedValue in updatedLabelValues {
            for label in mView.labels {
                if label.0 == updatedValue.0 {
                    label.1.text = String(format: "\(updatedValue.0): %.2f", updatedValue.1)
                }
            }
        }
    }
    
    private func updateOrientationLabel() {
        let orientation = UIDevice.current.orientation.toString
        for label in mView.labels {
            if label.0 == "orientation" {
                label.1.text = "orientation: \(orientation)"
            }
        }
    }
    
}

extension MotionTrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingString = String(format: "Heading: %.2f", newHeading.trueHeading)
        for label in mView.labels {
            if label.0 == "heading" {
                label.1.text = headingString
            }
        }
    }
}

// orientation change code
extension MotionTrackingViewController {
    private func updateConstraintsForCurrentOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            deactivateConstraints(portraitConstraints)
            activateConstraints(landscapeConstraints)
        case .portrait:
            deactivateConstraints(landscapeConstraints)
            activateConstraints(portraitConstraints)
        case .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    @objc private func handleOrientationChange(_ notification: Notification) {
        updateConstraintsForCurrentOrientation()
        updateOrientationLabel()
    }

    private func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach { $0.isActive = true }
    }

    private func deactivateConstraints(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach { $0.isActive = false }
    }
}

extension UIDeviceOrientation {
    var toString: String {
        switch self {
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
}
