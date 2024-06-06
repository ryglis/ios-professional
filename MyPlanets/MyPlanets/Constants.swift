//
//  Constants.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 24/02/2024.
//

import UIKit

struct K {
    static let radToDeg = 180.0 / .pi
    
    //names of localized labels keys for motion data
    static let elevationLabelKey = "elevationLabel"
    static let azimuthLabelKey = "azimuthLabel"
    
    //names of localizied labels keys for planet data
    static let planetElevationLabelKey = "planetElevationLabel"
    static let planetAzimuthLabelKey = "planetAzimuthLabel"
    
    //names of localized labels keys for location
    static let latitudeLabelKey = "latitudeLabel"
    static let longitudeLabelKey = "longitudeLabel"
    
    //keys of motion data
    static let rollValueKey = "roll"
    static let pitchValueKey = "pitch"
    static let yawValueKey = "yaw"
    //calculated
    static let elevationValueKey = "elevation"
    static let azimuthValueKey = "azimuth"
    static let deltaElevationValueKey = "deltaElevation"
    static let deltaAzimuthValueKey = "deltaAzimuth"
    static let pitchAngleValueKey = "pitchAngle"
    //keys of planet data
    static let planetElevationValueKey = "planetElevation"
    static let planetAzimuthValueKey = "planetAzimuth"

    
    // https://mycolor.space/?hex=%23090E26&sub=1
    static let backbgroundcolor = UIColor(red: 9/255.0, green: 14/255.0, blue: 38/255.0, alpha: 1.0)
    //Generic Gradiant
    static let lightbackground = UIColor(red: 0x4B/255.0, green: 0x2A/255.0, blue: 0x4E/255.0, alpha: 1.0)
    static let mediumPurple = UIColor(red: 0x96/255.0, green: 0x46/255.0, blue: 0x63/255.0, alpha: 1.0)
    static let lightPink = UIColor(red: 0xD7/255.0, green: 0x71/255.0, blue: 0x63/255.0, alpha: 1.0)
    static let paleYellow = UIColor(red: 0xFB/255.0, green: 0xAF/255.0, blue: 0x5C/255.0, alpha: 1.0)
    static let lightYellow = UIColor(red: 0xF9/255.0, green: 0xF8/255.0, blue: 0x71/255.0, alpha: 1.0)
    //Cube Palette
    static let tealBlue = UIColor(red: 0x00/255.0, green: 0xC6/255.0, blue: 0xC1/255.0, alpha: 1.0)
    static let lightCream = UIColor(red: 0xFF/255.0, green: 0xF7/255.0, blue: 0xD6/255.0, alpha: 1.0)
    
    //NASA API Parsing
    static let tableTextLineLenght = 84
    //Date
    static let dateStartIndex = 1
    static let dateLength = 11
    //RA
    static let rightAscStartIndex = 23
    static let rightAscLenght = 12
    static let rightAscHourOffset = 2
    static let rightAscMinuteStartIndex = 3
    static let rightAscMinuteOffset = 2
    static let rightAscSecondsStartIndex = 6
    static let rightAscSecondsOffset = 5
    //DEC
    static let declinationStartIndex = 35
    static let declinationLenght = 12
    static let declinationHourOffset = 3
    static let declinationMinuteStartIndex = 4
    static let declinationMinuteOffset = 2
    static let declinationSecondsStartIndex = 7
    static let declinationSecondsOffset = 4
    //Azimuth
    static let azimuthStartIndex = 48
    static let azimuthLenght = 10
    //Elevation
    static let elevationStartIndex = 59
    static let elevationLenght = 10
    //Apparent Sidereal Time
    static let astStartIndex = 71     //no length because we cut till the end of the line
    static let astHourOffset = 2
    static let astMinuteStartIndex = 3
    static let astMinuteOffset = 2
    static let astSecondsStartIndex = 6
    static let astSecondsOffset = 5
    
    static let minutesInHour = 60.0
    static let secondsInHour = 3600.0
    
    static func roundDouble(doubleToRound: Double) -> Double {
        let roundedDouble = Double(round(1000 * doubleToRound) / 1000)
        return roundedDouble
        
    }
}

/*
 Legacy:
 static let headingLabelKey = "headingLabel"
 static let orientationLabelKey = "orientationLabel"
 static let rollLabelKey = "rollLabel"
 static let pitchLabelKey = "pitchLabel"
 static let yawLabelKey = "yawLabel"
 
 

 static let headingValueKey = "heading"
 
 

 */
