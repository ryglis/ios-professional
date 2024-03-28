//
//  PlanetDataEfemerid.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 17/03/2024.
//

import Foundation

struct PlanetEfemerid {
    let efemeridParsedFromNASADataSuccessful: Bool
    let date: Date
    let rightAscension: Double
    let declination: Double
    let azimut: Double
    let elevation: Double
    let apparentSiderealTime: Double
    
    init (NASAparsingSuccessful: Bool, date: Date, rightAscension: Double, declination: Double, azimut: Double, elevation: Double, apparentSiderealTime: Double) {
        self.efemeridParsedFromNASADataSuccessful = NASAparsingSuccessful
        self.date = date
        self.rightAscension = rightAscension
        self.declination = declination
        self.azimut = azimut
        self.elevation = elevation
        self.apparentSiderealTime = apparentSiderealTime
    }
}
