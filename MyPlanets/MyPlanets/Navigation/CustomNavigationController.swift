//
//  CustomNavigationController.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 14/03/2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Check the topmost view controller in the navigation stack
        if let topViewController = self.topViewController {
            // Return supported orientations based on the topmost view controller
            if topViewController is PlanetsViewController {
                return .portrait // Set orientation for FirstViewController
            } else if topViewController is SkyViewController {
                return .landscape // Set orientation for SecondViewController
            }
        }
        // Default to all orientations if the top view controller is not recognized
        return .all
    }
    
}
