//
//  Constants.swift
//  MyPlanets
//
//  Created by Tomasz Rygula on 24/02/2024.
//

import UIKit

struct K {
    static let radToDeg = 180.0 / .pi
    static let mainColour: UIColor = {
        if #available(iOS 15.0, *) {
            return UIColor.systemMint
        } else {
            return UIColor.systemGray
        }
    }()
}
