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
    var sView: ScopeView!
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
    
    // Return false to prevent the view controller from autorotating
    override var shouldAutorotate: Bool {
        return true
    }
    
    // Specify which orientations are supported
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape // or any other specific orientation you want to support
    }
    //TODO: CONSTRAINTS
    
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
        
        initializeConstraints()
//        initializePortraitConstraints()
//        initializeLandscapeConstraints()
//        updateViewForCurrentOrientation()
//        drawdots()
        
    }
    
    private func initializeConstraints(){
        //let topAnchor = mView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        //let topAnchor = mView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        NSLayoutConstraint.activate([
            mView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            mView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
    //        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: lView.bottomAnchor, multiplier: 2)
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: lView.trailingAnchor, multiplier: 2),
            
            sView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func initializePortraitConstraints(){
        //let topAnchor = mView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        //let topAnchor = mView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        let centerAnchor = mView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let levelBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: lView.bottomAnchor, multiplier: 2)
        let levelSideAnchor = view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: lView.trailingAnchor, multiplier: 2)
        portraitConstraints.append(contentsOf: [centerAnchor, levelBottomAnchor, levelSideAnchor])
    }
    
    private func initializeLandscapeConstraints(){
        let leftAnchor = mView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2)
        let centerAnchor = mView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let levelTopAnchor = lView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
//        view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: lView.bottomAnchor, multiplier: 2)
        let levelSideAnchor = view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: lView.trailingAnchor, multiplier: 2)
        landscapeConstraints.append(contentsOf: [leftAnchor, centerAnchor, levelTopAnchor, levelSideAnchor])
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
        
    private func updateViewForCurrentOrientation() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .landscapeLeft, .landscapeRight:
//            mView.transform = CGAffineTransform.identity
            sView.transform = CGAffineTransform.identity
        case .portrait:
//            mView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // Rotate by 90 degrees (pi/2 radians)
            sView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2) // Rotate by 90 degrees (pi/2 radians)
        case .faceUp, .faceDown, .portraitUpsideDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    
    @objc private func handleOrientationChange(_ notification: Notification) {
        updateViewForCurrentOrientation()
        updateOrientationLabel()
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

extension MotionTrackingViewController {
    private func drawdots() {
        
        // Define the radius of the dots
        let radius: CGFloat = 5.0
        
        // Draw dots at the specified points
        let redPoints = [
            CGPoint(x: 33, y: 150),
            CGPoint(x: 356, y: 299),
            CGPoint(x: 195, y: 224),
            CGPoint(x: 120, y: 63),
            CGPoint(x: 299, y: 386),
            //CGPoint(x: 195, y: 224),
        ]
        
        let bluePoints = [
            CGPoint(x: 62, y: 33),
//            CGPoint(x: -27, y: 123),
//            CGPoint(x: 205, y: 357),
//            CGPoint(x: 296, y: 266),
//            CGPoint(x: 134, y: 195),
            //CGPoint(x: 195, y: 224),
        ]
        
        // Add a red dot as a subview for each point
        for point in redPoints {
            let dotView = UIView(frame: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
            dotView.backgroundColor = .red
            dotView.layer.cornerRadius = radius
            view.addSubview(dotView)
        }
        for point in bluePoints {
            let dotView = UIView(frame: CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2))
            dotView.backgroundColor = .blue
            dotView.layer.cornerRadius = radius
            view.addSubview(dotView)
        }
    }
}

