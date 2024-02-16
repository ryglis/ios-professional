//
//  PlanetsViewController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//
import UIKit

class PlanetsViewController: UIViewController {
    let scrollView = UIScrollView()
//    let tileWidth: CGFloat = 100.0
    let tileWidthPercentage: CGFloat = 0.9 // 90% of the screen width
//    let tileHeight: CGFloat = 150.0
    let numberOfTiles = 9
    let tileSpacing: CGFloat = 30.0
    var tiles: [PlanetTileView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        addTilesToScrollView()
    }
    
    private func setupScrollView() {
        view.backgroundColor = .systemBackground
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
        
        for index in 0..<numberOfTiles {
            let tileView = PlanetTileView()
            tileView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(tileView)
            tiles.append(tileView)
            
            tileView.didSelectButton = { [weak self] in
                // Handle navigation to details screen
                // You can push a new view controller here to show details
                self?.navigateToDetails(for: tileView)
            }
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
    
    private func navigateToDetails(for tileView: PlanetTileView) {
        // Handle navigation to details screen
    }
}
