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
    let motionTrackingView = MotionTrackingView()
    let levelView = LevelView()
    let scopeView = ScopeView()
    let levelErrorView = LevelErrorView()
    let planetView = PlanetView()
    var planetData: [String: Double]?
//    var planetData: [String: Double] = [K.planetElevationValueKey: 15.0, K.planetAzimuthValueKey: 156.0]
    var motionData = [String: Double]()
    var deltaAngels: [String: Double] = [K.deltaElevationValueKey: 0, K.deltaAzimuthValueKey: 0, K.pitchAngleValueKey: 0]
    let cameraViewController = CameraBackgroundViewController()
    var previousOrientation: UIDeviceOrientation = .unknown
    var lastLandscapeOrientation: UIDeviceOrientation = .landscapeLeft
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupMotionManager()
        setupLocationManager()
        updateErrorViewForOrientation()
        
        // Listen for device orientation changes
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
        previousOrientation = UIDevice.current.orientation
        
        
    }
    
//    // Specify which orientations are supported
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeRight
//    }
//    // Return false to prevent the view controller from autorotating
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    private func setupView() {
        view.backgroundColor = K.backbgroundcolor
//        view.backgroundColor = .clear
        
        addChild(cameraViewController)
        cameraViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraViewController.view)
        cameraViewController.didMove(toParent: self)
        
        motionTrackingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(motionTrackingView)
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
        guard let planetData = planetData else {
            planetData = [K.planetElevationValueKey: 0.0, K.planetAzimuthValueKey: 0.0]
            return
        }
        print("Dane planety: (hardcoded)")
        if let elevationValue = planetData[K.planetElevationValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.planetElevationLabelKey, elevationValue))
            print(K.planetElevationLabelKey, elevationValue)
        } else {
            // Handle the case where the key is not found in planetData
            print("Planet elevation value not found")
        }
        if let azimuthValue = planetData[K.planetAzimuthValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.planetAzimuthLabelKey, azimuthValue))
            print(K.planetAzimuthLabelKey, azimuthValue)
        } else {
            // Handle the case where the key is not found in planetData
            print("Planet azimuth value not found")
        }
        let sharedLocation = SharedLocation.values
        motionTrackingView.updateLabel(updatedLabel: (K.latitudeLabelKey, sharedLocation.latitude))
        motionTrackingView.updateLabel(updatedLabel: (K.longitudeLabelKey, sharedLocation.longitude))

    }
    
    private func initializeConstraints(){
        let maxSizeOfLabel = min(view.bounds.width, view.bounds.height)
        
        NSLayoutConstraint.activate([
            motionTrackingView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            motionTrackingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            levelView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: levelView.trailingAnchor, multiplier: 2),
            
            scopeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scopeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            planetView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            levelErrorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelErrorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            levelErrorView.widthAnchor.constraint(lessThanOrEqualToConstant: maxSizeOfLabel),
            
            cameraViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            cameraViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: Motion update
extension MotionTrackingViewController {
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
    
    private func updateViewDueToNewMotionData(_ newMotionData: CMAttitude) {
        let roll = newMotionData.roll * K.radToDeg
        let pitch = newMotionData.pitch * K.radToDeg
        let yaw = newMotionData.yaw * K.radToDeg
        let elevation = calculateElevation(roll: roll)
        let azimuth = calculateAzimuth(yaw: yaw)
        motionData[K.rollValueKey] = roll
        motionData[K.pitchValueKey] = pitch
        motionData[K.yawValueKey] = yaw
        motionData[K.elevationValueKey] = elevation
        motionData[K.azimuthValueKey] = azimuth
        
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
        case .landscapeRight:
            let result = (36000 + Int(-yaw100 + 18000)) % 36000
            azimuth = Double(result)
        default:
            let result = (36000 + Int(-yaw100)) % 36000
            azimuth = Double(result)
        }
        return azimuth/100
    }
    
    private func calculatePitchAngle() -> Double {
        let orientation = UIDevice.current.orientation
        var angleRad = 0.0
        if let pitch = motionData[K.pitchValueKey] {
            angleRad = pitch / K.radToDeg
        }
        switch orientation {
        case .landscapeLeft:
            angleRad = -angleRad
            levelView.isHidden = false
        case .landscapeRight:
            levelView.isHidden = false
        default:
            levelView.isHidden = true
        }
        return angleRad
    }
    
    private func updateMotionLabels() {
        if let roll = motionData[K.rollValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.rollLabelKey, roll))
        }
        if let pitch = motionData[K.pitchValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.pitchLabelKey, pitch))
        }
        if let yaw = motionData[K.yawValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.yawLabelKey, yaw))
        }
        if let elevation = motionData[K.elevationValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.elevationLabelKey, elevation))
        }
        if let azimuth = motionData[K.azimuthValueKey] {
            motionTrackingView.updateLabel(updatedLabel: (K.azimuthLabelKey, azimuth))
        }
    }
    
    private func updateLevelAngle() {
        let angleRad = calculatePitchAngle()
        levelView.updateLevelBasedOnMotion(angle: angleRad)
    }
    
    private func updateDeltaAngels() {
        guard let planetData = planetData else {
            planetData = [K.planetElevationValueKey: 0.0, K.planetAzimuthValueKey: 0.0]
            return
        }
        var deltaElevation = 0.0
        var deltaAzimuth = 0.0
        if let phoneElevation = motionData[K.elevationValueKey], let planetElevation = planetData[K.planetElevationValueKey] {
            deltaElevation = planetElevation - phoneElevation
        }
        if let phoneAzimuth = motionData[K.azimuthValueKey], let planetAzimuth = planetData[K.planetAzimuthValueKey] {
            deltaAzimuth = planetAzimuth - phoneAzimuth
        }
        if deltaAzimuth > 180 {
            deltaAzimuth -= 360
        } else if deltaAzimuth < -180 {
            deltaAzimuth += 360 
        }
        deltaAngels[K.deltaAzimuthValueKey] = deltaAzimuth
        deltaAngels[K.deltaElevationValueKey] = deltaElevation
        deltaAngels[K.pitchAngleValueKey] = calculatePitchAngle()
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
    
    func stopMotionUpdatesIfNeeded() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}

//MARK: Heading update
extension MotionTrackingViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateHeadingLabel(newHeading)
    }
    
    private func updateHeadingLabel(_ heading: CLHeading) {
        motionTrackingView.updateLabel(updatedLabel: (K.headingLabelKey, heading.trueHeading))
    }
    
    func stopHeadingUpdatesIfNeeded() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    switch self.locationManager.authorizationStatus {
                    case .authorizedAlways, .authorizedWhenInUse:
                        self.locationManager.stopUpdatingHeading() // Stop updating heading
                    default:
                        break // Do nothing if not authorized
                    }
                }
            }
        }
    }
    
    // CLLocationManagerDelegate method to handle authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        stopHeadingUpdatesIfNeeded()
    }
}

//MARK: Orientation change
extension MotionTrackingViewController {
        
    private func updateErrorViewForOrientation() {
        let orientation = UIDevice.current.orientation
        //show hide code
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            levelErrorView.isHidden = true
        default:
            levelErrorView.isHidden = false
        }
        //rotation code
        levelErrorView.transform = .identity
        if previousOrientation == .landscapeRight || lastLandscapeOrientation == .landscapeRight {
            switch orientation {
            case .portraitUpsideDown:
                levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
            default:
                levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            }
        } else {
            switch orientation {
            case .portraitUpsideDown:
                levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            default:
                levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
            }
        }
    }
    
    private func updateScopeViewForOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            scopeView.changeArrowVisibility(to: .visible)
        default:
            scopeView.changeArrowVisibility(to: .hidden)
        }
    }
    
    private func updateCameraViewForOrientation() {
        cameraViewController.orientationDidChange()
    }
    
    @objc private func handleOrientationChange(_ notification: Notification) {
        let orientation = UIDevice.current.orientation
        motionTrackingView.updateOrientationLabel(updatedLabel: K.orientationLabelKey)
        updateErrorViewForOrientation()
        updateScopeViewForOrientation()
        updateCameraViewForOrientation()
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            lastLandscapeOrientation = orientation
        }
        previousOrientation = orientation
    }
}

//MARK: View state management
extension MotionTrackingViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("I will disappear")
        // Stop motion updates
        stopHeadingUpdatesIfNeeded()
        stopMotionUpdatesIfNeeded()
    }
}

extension MotionTrackingViewController {
    @objc func popTapped(sender: UIButton) {
        navigationController?.popViewController(animated: false)
    }
}

