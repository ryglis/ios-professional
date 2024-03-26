//
//  PlanetsViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//
import UIKit
import CoreLocation

class PlanetsViewController: UIViewController {
    let scrollView = UIScrollView()
//    let tileWidth: CGFloat = 100.0
    let tileWidthPercentage: CGFloat = 0.9 // 90% of the screen width
//    let tileHeight: CGFloat = 150.0
    let tileSpacing: CGFloat = 24.0
    var tiles: [PlanetTileView] = []
    let planets = Planets.all
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addTilesToScrollView()
        initiateLocationManager()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return .portrait
    }
    
//    // Return false to prevent the view controller from autorotating
//    override var shouldAutorotate: Bool {
//        return false
//    }
    
    private func setupScrollView() {
        view.backgroundColor = K.backbgroundcolor
//        scrollView.frame = view.bounds
//        scrollView.contentSize = CGSize(width: view.bounds.width, height: CGFloat(numberOfTiles) * (tileHeight + tileSpacing))
        let safeArea = view.safeAreaLayoutGuide
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    

    private func addTilesToScrollView() {
//        var yOffset: CGFloat = 0.0
        let screenWidth = view.bounds.width
        let tileWidth = screenWidth * tileWidthPercentage
        var totalTileHeight: CGFloat = 0.0
        let numberOfTiles = planets.count
        
        for index in 0..<numberOfTiles {
            let tileView = PlanetTileView()
            tileView.translatesAutoresizingMaskIntoConstraints = false
            tileView.delegate = self
            tileView.nameLabel.text = planets[index].name
            tileView.descriptionLabel.text = planets[index].shortDescription
            tileView.imageView.image = UIImage(named: planets[index].imageName)
            scrollView.addSubview(tileView)
            tiles.append(tileView)
            
            // Add constraints for each tile
            NSLayoutConstraint.activate([
                tileView.widthAnchor.constraint(equalToConstant: tileWidth),
                tileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: (screenWidth - tileWidth) / 2),
                tileView.topAnchor.constraint(equalTo: index == 0 ? scrollView.topAnchor : tiles[index - 1].bottomAnchor, constant: tileSpacing)
            ])
            // Update totalTileHeight
            totalTileHeight += tileView.systemLayoutSizeFitting(CGSize(width: tileWidth, height: UIView.layoutFittingCompressedSize.height)).height
            
            // Add the bottom anchor constraint for the last tile
            if index == numberOfTiles - 1 {
                NSLayoutConstraint.activate([
                    tileView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -tileSpacing)
                ])
            }
        }
    }
}

extension PlanetsViewController: PlanetTileViewDelegate {
    
    func didSelectTileView(_ tileView: PlanetTileView) {
        // Create the planet data dictionary
        let planetData: [String: Double] = [
            K.planetElevationValueKey: 15.0,
            K.planetAzimuthValueKey: 156.0
            // Add more planet data as needed
        ]
        let motionTrackingVC = MotionTrackingViewController()
        motionTrackingVC.planetData = planetData
//        let motionTrackingVC = PushViewController()
        navigationController?.pushViewController(motionTrackingVC, animated: false)
    }
}

//MARK: - CLLocationManagerDelegate

extension PlanetsViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sharedLocation = SharedLocation.values
        if let location = locations.first {
            sharedLocation.updateSharedLocation(location: location)
            print("Got location data: latitude = \(sharedLocation.latitude), longitude = \(sharedLocation.longitude), height = \(sharedLocation.height), timestamp = \(sharedLocation.locationDate)")
            print("Current time = \(Date())")
//            initiatePlanetDataManager()
        }
        //TODO: a co jeśli nie dostałem lokalizacji? Czy to jest w ogóle możliwe?
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }
    
    func initiateLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // CLLocationManagerDelegate methods
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
      switch manager.authorizationStatus {
      case .authorizedWhenInUse, .authorizedAlways:
        locationManager.startMonitoringSignificantLocationChanges()
      case .denied, .restricted:
        // Handle the case where location authorization is denied or restricted
          print("Error fetching location: \(CLError(.locationUnknown))")
      case .notDetermined:
        // Authorization request in progress
        break
      default:
          print("Error fetching location: \(CLError(.locationUnknown))")
      }
    }
}

//MARK: View state management
extension PlanetsViewController {
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("I will disappear and kill location manager")
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

