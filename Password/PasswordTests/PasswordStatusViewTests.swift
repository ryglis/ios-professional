//
//  PasswordStatusViewTests.swift
//  PasswordTests
//
//  Created by Tomasz Rygula on 01/11/2023.
//

import XCTest

@testable import Password

class PasswordStatusViewTests_ShowCheckmarkOrReset_When_Validation_Is_Inline: XCTestCase {

    var statusView: PasswordStatusView!
    let validPassword = "12345678Aa!"
    let tooShort = "123Aa!"
    
    override func setUp() {
        super.setUp()
        statusView = PasswordStatusView()
        statusView.shouldResetCriteria = true // inline
    }

    /*
     if shouldResetCriteria {
         // Inline validation (✅ or ⚪️)
     } else {
         ...
     }
     */

    func testValidPassword() throws {
        statusView.updateDisplay(validPassword)
        XCTAssertTrue(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isCheckMarkImage) // ✅
    }
    
    func testTooShort() throws {
        statusView.updateDisplay(tooShort)
        XCTAssertFalse(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isResetImage) // ⚪️
    }
}


class PasswordStatusViewTests_ShowCheckmarkOrRedX_When_Validation_Is_Loss_Of_Focus: XCTestCase {

    var statusView: PasswordStatusView!
    let validPassword = "12345678Aa!"
    let tooShort = "123Aa!"

    override func setUp() {
        super.setUp()
        statusView = PasswordStatusView()
        statusView.shouldResetCriteria = false // loss of focus
    }

    /*
     if shouldResetCriteria {
         ...
     } else {
         // Focus lost (✅ or ❌)
     }
     */

    func testValidPassword() throws {
        statusView.updateDisplay(validPassword)
        XCTAssertTrue(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.uppercaseCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.uppercaseCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.lowerCaseCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lowerCaseCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.digitCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.digitCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.specialCharacterCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.specialCharacterCriteriaView.isCheckMarkImage)
    }

    func testTooShort() throws {
        statusView.updateDisplay(tooShort)
        XCTAssertFalse(statusView.lengthCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lengthCriteriaView.isXmarkImage)
        
        XCTAssertTrue(statusView.uppercaseCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.uppercaseCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.lowerCaseCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.lowerCaseCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.digitCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.digitCriteriaView.isCheckMarkImage)
        
        XCTAssertTrue(statusView.specialCharacterCriteriaView.isCriteriaMet)
        XCTAssertTrue(statusView.specialCharacterCriteriaView.isCheckMarkImage)
    }
}

class PasswordStatusViewTests_Validate_3Of4: XCTestCase {
    
    var statusView: PasswordStatusView!
    let validPassword4 = "12345678Aa!"
    let validPassword3 = "12345678Aa"
    let invalidPasswordLength = "123Aa!"
    let invalidPassword3 = "123456789abc"
    
    override func setUp() {
        super.setUp()
        statusView = PasswordStatusView()
        statusView.shouldResetCriteria = false // loss of focus
    }
    
    /*
     if shouldResetCriteria {
     ...
     } else {
     // Focus lost (✅ or ❌)
     }
     */
    
    func testValidPassword4() throws {
        XCTAssertTrue(statusView.validate(validPassword4))
    }
    func testValidPassword3() throws {
        XCTAssertTrue(statusView.validate(validPassword3))
    }
    func testInvalidPasswordLength() throws {
        XCTAssertFalse(statusView.validate(invalidPasswordLength))
    }
    func testInvalidPassword3() throws {
        XCTAssertFalse(statusView.validate(invalidPassword3))
    }
}


