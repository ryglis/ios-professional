//
//  CameraView.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 08/03/2024.
//

import UIKit
import AVFoundation

class CameraBackgroundViewController: UIViewController {

    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var cameraButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up AVCaptureSession
        captureSession = AVCaptureSession()

        // Add camera toggle button
        self.cameraButton = setupButton()
        
        // Add an observer for device orientation changes
//        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeRight // or any other specific orientation you want to support
//    }

    @objc func toggleButtonClicked() {
        let cameraOn = toggleCamera()
        toggleButton(cameraOn: cameraOn)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let session = captureSession {
            if session.isRunning {
                session.stopRunning()
            }
        }
        
    }
    
    func toggleCamera() -> Bool {
        guard let session = captureSession else { return false }

        if session.isRunning {
            print("togle camera - session is running")
            session.stopRunning()
            view.backgroundColor = K.backbgroundcolor
            // Stop the preview layer
            previewLayer?.removeFromSuperlayer()
            previewLayer = nil
            return false
        } else {
            print("togle camera - session is NOT running")

            // Set up the device
            guard let camera = AVCaptureDevice.default(for: .video) else {
                view.backgroundColor = K.backbgroundcolor
                return false
            }
            do {
                // Input
                let cameraInput = try AVCaptureDeviceInput(device: camera)
                if session.canAddInput(cameraInput) {
                    session.addInput(cameraInput)
                } else {
                    print("Error: Unable to add camera input to capture session.")
                }

                // Output
                let newPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                newPreviewLayer.videoGravity = .resizeAspectFill
                newPreviewLayer.frame = view.layer.bounds

                // Set video orientation to landscape mode
                if let connection = newPreviewLayer.connection, connection.isVideoOrientationSupported {
                    connection.videoOrientation = .landscapeRight // or .landscapeLeft depending on your preference
                }
                
                view.layer.insertSublayer(newPreviewLayer, at: 0)
                previewLayer = newPreviewLayer

                // Start the session
                DispatchQueue.global().async {
                    session.startRunning()
                    print("session started in async")
                }
                view.backgroundColor = .clear
                return true
            } catch {
                print(error.localizedDescription)
                view.backgroundColor = K.backbgroundcolor
            }
        }
        return false
    }
    
    func toggleButton(cameraOn:Bool) {
        if cameraOn {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
            let image = UIImage(systemName: "camera", withConfiguration: symbolConfiguration)
            cameraButton?.setImage(image, for: .normal)
//            cameraButton?.setTitle("Turn Camera OFF", for: .normal)
        } else {
            let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
            let image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
            cameraButton?.setImage(image, for: .normal)
//            cameraButton?.setTitle("Turn Camera ON", for: .normal)
        }
    }
    
    func setupButton() -> UIButton {
        let button = UIButton(type: .system)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.tintColor = K.tealBlue
        button.addTarget(self, action: #selector(toggleButtonClicked), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: button.trailingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: button.bottomAnchor, multiplier: 2),
        ])
        return button
    }
    // Remove observer when the view is deinitialized
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

//MARK: Orientation change code - not needed when orientation fixed

extension CameraBackgroundViewController {
    // Handle device orientation changes
    func orientationDidChange() {
        guard let connection =  self.previewLayer?.connection else { return }
        let currentDevice: UIDevice = UIDevice.current
        let orientation: UIDeviceOrientation = currentDevice.orientation
        guard let previewLayer = self.previewLayer else { return }
        
        if connection.isVideoOrientationSupported {
            switch orientation {
            case .landscapeRight:
                connection.videoOrientation = .landscapeLeft
                previewLayer.frame = view.layer.bounds
            case .landscapeLeft:
                connection.videoOrientation = .landscapeRight
                previewLayer.frame = view.layer.bounds
            default:
                break          
            }
        }
    }
}


