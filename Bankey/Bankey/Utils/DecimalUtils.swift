//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Tomasz Rygula on 11/09/2023.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}
