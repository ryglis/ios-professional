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
    let mView = MotionTrackingView()
    let lView = LevelView()
    let sView = ScopeView()
    let lErrView = LevelErrorView()
    let planetElevation = ("planet Ele", 15.0)
    let planetAzimuth = ("planet Azi", 56.0)
    var deltaAngels: [String: Double] = [
        "deltaAzimuth": 0,
        "deltaElevation": 0
    ]
    
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
        mView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mView)
        
        lView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lView)
        
        sView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sView)
        
        lErrView.translatesAutoresizingMaskIntoConstraints = false
        lErrView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
        view.addSubview(lErrView)
        
        mView.updateLabel(updatedLabel: planetElevation)
        mView.updateLabel(updatedLabel: planetAzimuth)
        print("Dane planety: (hardcoded)")
        print(planetElevation)
        print(planetAzimuth)
        
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
}

//MARK: Motion update
extension MotionTrackingViewController {
    private func updateMotion(_ attitude: CMAttitude) {
        updateMotionLabels(attitude)
        let pitch = attitude.pitch
        updateLevelAngle(pitch)
        updateDeltaAngels(attitude)
        sView.updateArrow(deltaAngels: deltaAngels)
    }
//TODO: I need to check if close by and remove arrow and show a bal!!!!!!
    
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
        lView.updateLevelBasedOnMotion(angle: angleRad)
    }
    
    private func updateMotionLabels(_ attitude: CMAttitude) {
        let roll = attitude.roll * K.radToDeg
        let pitch = attitude.pitch * K.radToDeg
        let yaw = attitude.yaw * K.radToDeg
        let elevation = calculateElevation(roll: roll)
        let azimuth = calculateAzimuth(yaw: yaw)
        let updatedLabelValues = [
            ("roll", roll),
            ("pitch", pitch),
            ("yaw", yaw),
            ("elevation", elevation),
            ("azimuth", azimuth),
        ]
        for updatedValue in updatedLabelValues {
            mView.updateLabel(updatedLabel: updatedValue)
        }
    }
    
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
            let result = (36000 + Int(-yaw100)) % 36000
            azimuth = Double(result)
        case .landscapeRight:
            let result = (36000 + Int(-yaw100 + 18000)) % 36000
            azimuth = Double(result)
        @unknown default:
            break
        }
        return azimuth/100
    }
    
    private func updateDeltaAngels(_ attitude: CMAttitude) {
        let roll = attitude.roll * K.radToDeg
        let yaw = attitude.yaw * K.radToDeg
        let elevation = calculateElevation(roll: roll)
        let azimuth = calculateAzimuth(yaw: yaw)
        let deltaElevation = planetElevation.1 - elevation
        var deltaAzimuth = planetAzimuth.1 - azimuth
        if deltaAzimuth > 180 {
            deltaAzimuth -= 360
        } else if deltaAzimuth < -180 {
            deltaAzimuth += 360 
        }
        deltaAngels["deltaAzimuth"] = deltaAzimuth
        deltaAngels["deltaElevation"] = deltaElevation
    }
}

//MARK: Heading update
extension MotionTrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateHeadingLabel(newHeading)
    }
    
    private func updateHeadingLabel(_ heading: CLHeading) {
        let headingString = String(format: "Heading: %.2f", heading.trueHeading)
        for label in mView.labels {
            if label.0 == "heading" {
                label.1.text = headingString
            }
        }
    }
}

//MARK: Orientation change
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
}


//TODO: MOVE TO APPDELEGATE - see below
//MARK: View state management
extension MotionTrackingViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("I have disappeared")
        // Stop motion updates
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
        // Stop location updates
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
}

//In your UIApplicationDelegate subclass (e.g., AppDelegate.swift), define a protocol for handling lifecycle events:
//protocol AppLifecycleDelegate: AnyObject {
//    func applicationWillEnterForeground()
//    // Add more methods for other lifecycle events as needed
//}


//In your AppDelegate, create a weak reference to the delegate:
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    weak var lifecycleDelegate: AppLifecycleDelegate?
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        lifecycleDelegate?.applicationWillEnterForeground()
//    }
//    // Implement other app delegate methods as needed
//}


//In your view controller, conform to the AppLifecycleDelegate protocol and implement the methods to update your view:
//class YourViewController: UIViewController, AppLifecycleDelegate {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Set the app delegate's lifecycle delegate to self
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.lifecycleDelegate = self
//        }
//    }
//
//    func applicationWillEnterForeground() {
//        // Update your view when the app enters the foreground
//        // Example: Reload data, refresh UI, etc.
//    }
//    // Implement other methods from the AppLifecycleDelegate protocol as needed
//}
//
