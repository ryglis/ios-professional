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
    var lView: LevelView!
    var lErrView: LevelErrorView!
    var sView: ScopeView!
    var backgroundView: UIView!
    
    let radToDeg = 180.0 / .pi
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupMotionManager()
        setupLocationManager()
        // Listen for device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // Return false to prevent the view controller from autorotating
    override var shouldAutorotate: Bool {
        return true
    }
    
    // Specify which orientations are supported
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // or any other specific orientation you want to support
    }
    
    private func setupView() {
        mView = MotionTrackingView()
        mView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mView)
        
        lView = LevelView()
        lView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lView)
        
        sView = ScopeView()
        sView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sView)
        
        lErrView = LevelErrorView()
        lErrView.translatesAutoresizingMaskIntoConstraints = false
        lErrView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
        view.addSubview(lErrView)
        
        initializeConstraints()

    }
    
    private func initializeConstraints(){
        let maxSizeOfLabel = min(view.bounds.width, view.bounds.height)
        let maxSizeOfScreen = max(view.bounds.width, view.bounds.height)
        let constantMargin = (maxSizeOfScreen - maxSizeOfLabel) / 2
        
        NSLayoutConstraint.activate([
            mView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            mView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            lView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: lView.trailingAnchor, multiplier: 2),
            
            sView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            lErrView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lErrView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lErrView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: constantMargin),
          // lErrView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constantMargin),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: lErrView.trailingAnchor, constant: constantMargin),
            
        ])
    }
    
    private func setupMotionManager() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.showsDeviceMovementDisplay = true
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical ,to: .main) { [weak self] (data, error) in
                guard let attitude = data?.attitude else { return }
                self?.updateMotion(attitude)
            }
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    private func updateMotion(_ attitude: CMAttitude) {
        updateMotionLabels(attitude)
        let pitch = attitude.pitch
        updateLevelAngle(pitch)
    }
    
    private func updateLevelAngle(_ pitch: Double) {
        let orientation = UIDevice.current.orientation
        var angleRad = pitch
        switch orientation {
        case .landscapeLeft, .portrait, .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            angleRad = -angleRad
        case .landscapeRight:
            break
        @unknown default:
            break
        }
        lView.levelView.transform = CGAffineTransform.init(rotationAngle: (angleRad))
        let angle = abs(angleRad) * radToDeg
        if angle < 20 {
            lView.levelView.tintColor = .systemGreen.withAlphaComponent(0.5)
            lView.levelLabel.textColor = .white.withAlphaComponent(0.5)
        } else {
            lView.levelView.tintColor = .systemRed
            lView.levelLabel.textColor = .systemRed
        }
    }
    
    private func updateMotionLabels(_ attitude: CMAttitude) {
  
        let roll = attitude.roll * radToDeg
        let pitch = attitude.pitch * radToDeg
        let yaw = attitude.yaw * radToDeg
        let elevation = calculateElevation(roll: roll)
        let azimuth = calculateAzimuth(yaw: yaw)
//        let quaternion = attitude.quaternion
//        let w = quaternion.w
//        let x = quaternion.x
//        let y = quaternion.y
//        let z = quaternion.z
//        let theta = 2 * acos(w)
//        let thetaDeg = theta * radToDeg
//        let magnitude = sqrt(w * w + x * x + y * y + z * z)
        
        let updatedLabelValues = [
            ("roll", roll),
            ("pitch", pitch),
            ("yaw", yaw),
            ("elevation", elevation),
            ("azimuth", azimuth),
//            ("w", w),
//            ("x", x),
//            ("y", y),
//            ("z", z),
//            ("theta", theta),
//            ("thetaDeg", thetaDeg),
//            ("q", magnitude),
        ]
        
        for updatedValue in updatedLabelValues {
            for label in mView.labels {
                if label.0 == updatedValue.0 {
                    label.1.text = String(format: "\(updatedValue.0.capitalized): %.2f", updatedValue.1)
                }
            }
        }
    }
    
}

extension MotionTrackingViewController {
    private func calculateElevation(roll: Double) -> Double {
        let elevation = abs(roll) - 90
        return elevation
    }
    
    private func calculateAzimuth(yaw: Double) -> Double {
        let orientation = UIDevice.current.orientation
        var azimuth = 0.0
        let yaw100 = yaw * 100
        switch orientation {
        case .landscapeLeft, .portrait, .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            //azimuth = (360.0 + (-yaw + 270.0)).truncatingRemainder(dividingBy: 360.0)
            let result = (36000 + Int(-yaw100)) % 36000
            azimuth = Double(result)
        case .landscapeRight:
            //azimuth = (360.0 + (yaw + 270.0)).truncatingRemainder(dividingBy: 360.0)
            let result = (36000 + Int(-yaw100 + 18000)) % 36000
            azimuth = Double(result)
        @unknown default:
            break
        }
//        We calculate (-yaw + 270).
//        We add 360 to ensure that the result is positive or zero before taking the modulo operation. This is to handle negative values properly.
//        Then, we take the modulo 360 to ensure that the result is within the range [0, 360).
        return azimuth/100
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
        
    private func updateViewForCurrentOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            lErrView.isHidden = true
        case .portrait:
            lErrView.isHidden = false
        case .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleOrientationChange(_ notification: Notification) {
        updateViewForCurrentOrientation()
    }

    private func activateConstraints(_ constraints: [NSLayoutConstraint]) {
        constraints.forEach {$0.isActive = true}
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

