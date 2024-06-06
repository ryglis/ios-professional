//
//  PlanetsViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//
import UIKit
import CoreLocation

//TODO: Photo by <a href="https://unsplash.com/@nasa?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">NASA</a> on <a href="https://unsplash.com/photos/uranus-planet-Li41RApUAQA?utm_content=creditCopyText&utm_medium=referral&utm_source=unsplash">Unsplash</a>


class PlanetsViewController: UIViewController {
    let scrollView = UIScrollView()
    let tileWidthPercentage: CGFloat = 0.9 // 90% of the screen width
    let tileSpacing: CGFloat = 24.0
    var tiles: [PlanetTileView] = []
    let planets = Planets.all
    let locationManager = CLLocationManager()
    let apiManager = PlanetAPIManager()
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
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
            
//             Calculate the desired height of the image based on its aspect ratio
            guard let image = tileView.imageView.image else { continue }
            let imageAspectRatio = image.size.width / image.size.height
            let imageHeight = tileWidth / imageAspectRatio
            
            // Add constraints for each tile
            NSLayoutConstraint.activate([
                tileView.widthAnchor.constraint(equalToConstant: tileWidth),
                tileView.imageView.heightAnchor.constraint(equalToConstant: imageHeight), // Set the height of the image view
                tileView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: (screenWidth - tileWidth) / 2),
                tileView.topAnchor.constraint(equalTo: index == 0 ? scrollView.topAnchor : tiles[index - 1].bottomAnchor, constant: tileSpacing)
            ])
            
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
        if let index = tiles.firstIndex(where: { $0 === tileView }) {
            // Index found, do something with it
            print("Index of tapped tile:", index)
            let planet = planets[index]
            planetSelected(planet: planet)
        } else {
            // Tile not found in the array
            print("Tapped tile not found in the tiles array")
        }
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
        locationManager.stopMonitoringSignificantLocationChanges()
    }
}

//MARK: Planet API extension
extension PlanetsViewController {
    // Function called when planet is selected
    func planetSelected(planet: Planet) {
        // Create the planet data dictionary
        alert = showLoadingAlert()
        //API call
        apiManager.planet = planet
        apiManager.fetchPlanetData()
        
    }
    
    func showLoadingAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Proszę czekać", message: "Trwa pobieranie danych...", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Błąd", message: "Nie udało się pobrać danych. Spróbuj ponownie później.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: Planet API Manager delegate
extension PlanetsViewController: PlanetAPIManagerDelegate {
    func didFetchPlanetData(forPlanet: Planet) {
        
        print("Wielki sukces")
        
        if let currentAlert = alert {
            currentAlert.dismiss(animated: true)
        }

        let skyViewCcontroller = SkyViewController()
        skyViewCcontroller.planet = forPlanet
        self.navigationController?.pushViewController(skyViewCcontroller, animated: false)
        
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
    
    
}
