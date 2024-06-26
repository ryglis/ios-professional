//
//  NightSkyViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 31/01/2024.
//

import UIKit
import CoreMotion
import CoreLocation

class SkyViewController: UIViewController {
    let motionManager = CMMotionManager()
//    let locationManager = CLLocationManager()
//    let dataView = MotionTrackingView()
    let dataView = TrackingDataView()
    let levelView = LevelView()
    let scopeView = ScopeView()
    let levelErrorView = LevelErrorView()
    let planetView = PlanetView()
    var planet: Planet?

    var planetData: [String: Double] = [K.planetElevationValueKey: 0.0, K.planetAzimuthValueKey: 0.0]
    var trackingData = [String: Double]()
    var deltaAngels: [String: Double] = [K.deltaElevationValueKey: 0, K.deltaAzimuthValueKey: 0, K.pitchAngleValueKey: 0]
    let cameraViewController = CameraBackgroundViewController()
    var previousOrientation: UIDeviceOrientation = .unknown
    var lastLandscapeOrientation: UIDeviceOrientation = .landscapeLeft
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupMotionManager()
//        setupLocationManager()
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
        
        dataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataView)
        updatePlanetLabels()
        updateLocationLabels()
        
        levelView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelView)
        
        scopeView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scopeView)
        
        planetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(planetView)
        updatePlanetName()
        
        levelErrorView.translatesAutoresizingMaskIntoConstraints = false
        levelErrorView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / (-2))
        view.addSubview(levelErrorView)
        
        initializeConstraints()
        
    }
    
    private func updatePlanetLabels() {
        var elevation: Double = 0.0
        var azimut: Double = 0.0
        if let fetchedAzimut = planet?.efemerid?.azimut {
            print("Azymut pozyskany = \(fetchedAzimut)")
            azimut = fetchedAzimut
        }
        if let fetchedElevation = planet?.efemerid?.elevation {
            print("Elewacja pozyskana = \(fetchedElevation)")
            elevation = fetchedElevation
        }
        planetData = [K.planetElevationValueKey: elevation, K.planetAzimuthValueKey: azimut]

        dataView.updateLabel(updatedLabel: (K.planetElevationLabelKey, elevation))
        print(K.planetElevationLabelKey, elevation)
        dataView.updateLabel(updatedLabel: (K.planetAzimuthLabelKey, azimut))
        print(K.planetAzimuthLabelKey, azimut)
    }
    
    private func updatePlanetName() {
        if let planetName = planet?.name {
            planetView.updatePlanetName(planetName: planetName)
        }
    }
    
    private func updateLocationLabels() {
        let sharedLocation = SharedLocation.values
        dataView.updateLabel(updatedLabel: (K.latitudeLabelKey, sharedLocation.latitude))
        dataView.updateLabel(updatedLabel: (K.longitudeLabelKey, sharedLocation.longitude))
    }
    
    private func initializeConstraints(){
        let maxSizeOfLabel = min(view.bounds.width, view.bounds.height)
        
        NSLayoutConstraint.activate([
            dataView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            dataView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
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
extension SkyViewController {
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
        trackingData[K.rollValueKey] = roll
        trackingData[K.pitchValueKey] = pitch
        trackingData[K.yawValueKey] = yaw
        trackingData[K.elevationValueKey] = elevation
        trackingData[K.azimuthValueKey] = azimuth
        
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
        if let pitch = trackingData[K.pitchValueKey] {
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
//        if let roll = trackingData[K.rollValueKey] {
//            dataView.updateLabel(updatedLabel: (K.rollLabelKey, roll))
//        }
//        if let pitch = trackingData[K.pitchValueKey] {
//            dataView.updateLabel(updatedLabel: (K.pitchLabelKey, pitch))
//        }
//        if let yaw = trackingData[K.yawValueKey] {
//            dataView.updateLabel(updatedLabel: (K.yawLabelKey, yaw))
//        }
        if let elevation = trackingData[K.elevationValueKey] {
            dataView.updateLabel(updatedLabel: (K.elevationLabelKey, elevation))
        }
        if let azimuth = trackingData[K.azimuthValueKey] {
            dataView.updateLabel(updatedLabel: (K.azimuthLabelKey, azimuth))
        }
    }
    
    private func updateLevelAngle() {
        let angleRad = calculatePitchAngle()
        levelView.updateLevelBasedOnMotion(angle: angleRad)
    }
    
    private func updateDeltaAngels() {
        var deltaElevation = 0.0
        var deltaAzimuth = 0.0
        if let phoneElevation = trackingData[K.elevationValueKey], let planetElevation = planetData[K.planetElevationValueKey] {
            deltaElevation = planetElevation - phoneElevation
        }
        if let phoneAzimuth = trackingData[K.azimuthValueKey], let planetAzimuth = planetData[K.planetAzimuthValueKey] {
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

////MARK: Heading update
//extension SkyViewController: CLLocationManagerDelegate {
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.startUpdatingHeading()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        updateHeadingLabel(newHeading)
//    }
//    
//    private func updateHeadingLabel(_ heading: CLHeading) {
//        dataView.updateLabel(updatedLabel: (K.headingLabelKey, heading.trueHeading))
//    }
//    
//    func stopHeadingUpdatesIfNeeded() {
//        DispatchQueue.global().async {
//            if CLLocationManager.locationServicesEnabled() {
//                DispatchQueue.main.async {
//                    switch self.locationManager.authorizationStatus {
//                    case .authorizedAlways, .authorizedWhenInUse:
//                        self.locationManager.stopUpdatingHeading() // Stop updating heading
//                    default:
//                        break // Do nothing if not authorized
//                    }
//                }
//            }
//        }
//    }
//    
//    // CLLocationManagerDelegate method to handle authorization changes
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        stopHeadingUpdatesIfNeeded()
//    }
//}

//MARK: Orientation change
extension SkyViewController {
        
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
//        dataView.updateOrientationLabel(updatedLabel: K.orientationLabelKey)
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
extension SkyViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop motion updates
//        stopHeadingUpdatesIfNeeded()
        stopMotionUpdatesIfNeeded()
    }
}


