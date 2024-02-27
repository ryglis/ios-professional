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
    let motionDataView = MotionTrackingView()
    let levelView = LevelView()
    let scopeView = ScopeView()
    let levelErrorView = LevelErrorView()
    let planetView = PlanetView()
    let planetData: [String: Double] = ["planet Ele": 15.0, "planet Azi": 56.0]
    var motionData = [String: Double]()
    var deltaAngels: [String: Double] = ["deltaAzimuth": 0, "deltaElevation": 0]
    
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
        motionDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(motionDataView)
        updatePlanetLabels()
        
        levelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelView)
        
        scopeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scopeView)
        
        planetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(planetView)
        
        levelErrorView.translatesAutoresizingMaskIntoConstraints = false
        levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
        view.addSubview(levelErrorView)
        
        initializeConstraints()
        
    }
    
    private func updatePlanetLabels() {
        print("Dane planety: (hardcoded)")
        for (key, value) in planetData {
            motionDataView.updateLabel(updatedLabel: (key, value))
            print(key, value)
        }
    }
    
    private func initializeConstraints(){
        let maxSizeOfLabel = min(view.bounds.width, view.bounds.height)
        let maxSizeOfScreen = max(view.bounds.width, view.bounds.height)
        let constantMargin = (maxSizeOfScreen - maxSizeOfLabel) / 2
        
        NSLayoutConstraint.activate([
            motionDataView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            motionDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            levelView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: levelView.trailingAnchor, multiplier: 2),
            
            scopeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scopeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            planetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            levelErrorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelErrorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            levelErrorView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: constantMargin),
            view.trailingAnchor.constraint(greaterThanOrEqualTo: levelErrorView.trailingAnchor, constant: constantMargin),
        ])
    }
    
    private func setupMotionManager() {
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.showsDeviceMovementDisplay = true
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical ,to: .main) { [weak self] (data, error) in
                guard let attitude = data?.attitude else { return }
                self?.updateViewDueToNewMotionData(attitude)
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
    private func updateViewDueToNewMotionData(_ newMotionData: CMAttitude) {
        let roll = newMotionData.roll * K.radToDeg
        let pitch = newMotionData.pitch * K.radToDeg
        let yaw = newMotionData.yaw * K.radToDeg
        let elevation = calculateElevation(roll: roll)
        let azimuth = calculateAzimuth(yaw: yaw)
        motionData["roll"] = roll
        motionData["pitch"] = pitch
        motionData["yaw"] = yaw
        motionData["elevation"] = elevation
        motionData["azimuth"] = azimuth
        
        updateMotionLabels()
        updateLevelAngle()
        updateDeltaAngels()
        updatepPlanetPosition()
        updateArrow()
    }
//
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
    
    private func updateMotionLabels() {
        if let roll = motionData["roll"] {
            motionDataView.updateLabel(updatedLabel: ("roll", roll))
        }
        if let pitch = motionData["pitch"] {
            motionDataView.updateLabel(updatedLabel: ("pitch", pitch))
        }
        if let yaw = motionData["yaw"] {
            motionDataView.updateLabel(updatedLabel: ("yaw", yaw))
        }
        if let elevation = motionData["elevation"] {
            motionDataView.updateLabel(updatedLabel: ("elevation", elevation))
        }
        if let azimuth = motionData["azimuth"] {
            motionDataView.updateLabel(updatedLabel: ("azimuth", azimuth))
        }
    }
    
    private func updateLevelAngle() {
        let orientation = UIDevice.current.orientation
        var angleRad = 0.0
        if let pitch = motionData["pitch"] {
            angleRad = pitch / K.radToDeg
        }
        switch orientation {
        case .landscapeLeft, .portrait, .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            angleRad = -angleRad
        case .landscapeRight:
            break
        @unknown default:
            break
        }
        levelView.updateLevelBasedOnMotion(angle: angleRad)
    }
    
    private func updateDeltaAngels() {
        var deltaElevation = 0.0
        var deltaAzimuth = 0.0
        if let phoneElevation = motionData["elevation"], let planetElevation = planetData["planet Ele"] {
            deltaElevation = planetElevation - phoneElevation
        }
        if let phoneAzimuth = motionData["azimuth"], let planetAzimuth = planetData["planet Azi"] {
            deltaAzimuth = planetAzimuth - phoneAzimuth
        }
        if deltaAzimuth > 180 {
            deltaAzimuth -= 360
        } else if deltaAzimuth < -180 {
            deltaAzimuth += 360 
        }
        deltaAngels["deltaAzimuth"] = deltaAzimuth
        deltaAngels["deltaElevation"] = deltaElevation
    }

    private func updatepPlanetPosition() {
        planetView.updatePlanetPosition(deltaAngels: deltaAngels)
    }
    
    private func updateArrow() {
        scopeView.updateArrow(deltaAngels: deltaAngels)
        if planetView.planetOnScreen() {
            scopeView.changeArrowVisibility(to: .hidden)
        } else {
            scopeView.changeArrowVisibility(to: .visible)
        }
    }
}

//MARK: Heading update
extension MotionTrackingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateHeadingLabel(newHeading)
    }
    
    private func updateHeadingLabel(_ heading: CLHeading) {
        let headingString = String(format: "Heading: %.2f", heading.trueHeading)
        for label in motionDataView.labels {
            if label.0 == "heading" {
                label.1.text = headingString
            }
        }
    }
}

//MARK: Orientation change
extension MotionTrackingViewController {
        
    private func updateErrorViewForOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            levelErrorView.isHidden = true
        case .portrait:
            levelErrorView.isHidden = false
        case .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleOrientationChange(_ notification: Notification) {
        updateErrorViewForOrientation()
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
