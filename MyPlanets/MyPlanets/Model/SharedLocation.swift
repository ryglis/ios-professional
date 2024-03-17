//
//  SharedLocation.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 17/03/2024.
//

import Foundation
import CoreLocation

class SharedLocation {
    var locationAquired = false
    var locationDate = Date()
    var latitude = 0.0
    var longitude = 0.0
    var height = 0.0
    
    static let values = SharedLocation()
        //SINGLETON !!!
    
    func updateSharedLocation(location: CLLocation) {
        latitude = K.roundDouble(doubleToRound: location.coordinate.latitude)
        longitude = K.roundDouble(doubleToRound: location.coordinate.longitude)
        height = location.ellipsoidalAltitude
        locationAquired = true
        locationDate = location.timestamp
    }
}

