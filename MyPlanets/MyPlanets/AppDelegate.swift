//
//  AppDelegate.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 30/01/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
//        let navigationController = UINavigationController(rootViewController: PlanetsViewController())
        let navigationController = CustomNavigationController(rootViewController: PlanetsViewController())
//        let navigationController = CustomNavigationController(rootViewController: MotionTrackingViewController())

//        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
//        window?.rootViewController = MotionTrackingViewController()
//        window?.rootViewController = PlanetsViewController()
//        window?.rootViewController = PushViewController()
        
        return true
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//      return .portrait // Or your desired orientation
//    }


}

