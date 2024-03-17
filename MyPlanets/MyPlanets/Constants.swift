//
//  Constants.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 24/02/2024.
//

import UIKit

struct K {
    static let radToDeg = 180.0 / .pi
    
    static let rollLabelKey = "rollLabel"
    static let pitchLabelKey = "pitchLabel"
    static let yawLabelKey = "yawLabel"
    static let elevationLabelKey = "elevationLabel"
    static let azimuthLabelKey = "azimuthLabel"
    static let headingLabelKey = "headingLabel"
    static let planetElevationLabelKey = "planetElevationLabel"
    static let planetAzimuthLabelKey = "planetAzimuthLabel"
    static let orientationLabelKey = "orientation"
    
    static let rollValueKey = "roll"
    static let pitchValueKey = "pitch"
    static let yawValueKey = "yaw"
    static let elevationValueKey = "elevation"
    static let azimuthValueKey = "azimuth"
    static let headingValueKey = "heading"
    static let planetElevationValueKey = "planetElevation"
    static let planetAzimuthValueKey = "planetAzimuth"
    static let deltaElevationValueKey = "deltaElevation"
    static let deltaAzimuthValueKey = "deltaAzimuth"
    
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
    
    static func roundDouble(doubleToRound: Double) -> Double {
        let roundedDouble = Double(round(1000 * doubleToRound) / 1000)
        return roundedDouble
    }
}
