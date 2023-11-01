//
//  PasswordCirteriaTests.swift
//  PasswordTests
//
//  Created by Tomasz Rygula on 01/11/2023.
//

import Foundation

import XCTest

@testable import Password

class PasswordLengthCriteriaTests: XCTestCase {

    // Boundary conditions 8-32
    
    func testShort() throws { //7
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("1234567"))
    }

    func testLong() throws { //33
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("123456789012345678901234567890123"))
    }
    
    func testValidShort() throws { //8
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678"))
    }
    
    func testValidMedium() throws { //16
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("1234567890123456"))
    }

    func testValidLong() throws { //32
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678901234567890123456789012"))
    }
}

class PasswordOtherCriteriaTests: XCTestCase {
    //no space
    func testSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.noSpaceCriteriaMet("abc"))
    }
    func testSpaceNotMet() throws {
        XCTAssertFalse(PasswordCriteria.noSpaceCriteriaMet("a bc"))
    }
    //length and space
    func testLengthAndSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.lengthAndNoSpaceMet("12345678"))
    }
    func testLengthAndSpaceNotMet1() throws {
        XCTAssertFalse(PasswordCriteria.lengthAndNoSpaceMet("1234 5678"))
    }
    func testLengthAndSpaceNotMet2() throws {
        XCTAssertFalse(PasswordCriteria.lengthAndNoSpaceMet("1234567"))
    }
    //uppercase
    func testUppercaseMet() throws {
        XCTAssertTrue(PasswordCriteria.uppercaseMet("D"))
    }
    func testUppercaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.uppercaseMet("abcd"))
    }
    //lowercase
    func testLowercaseMet() throws {
        XCTAssertTrue(PasswordCriteria.lowercaseMet("12qD"))
    }
    func testLowercaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lowercaseMet("12345EF$D"))
    }
    //digit
    func testDigitMet() throws {
        XCTAssertTrue(PasswordCriteria.digitMet("a 1"))
    }
    func testDigitNotMet() throws {
        XCTAssertFalse(PasswordCriteria.digitMet("aewiurj%$vfSEF"))
    }
    //special character
    func testSepcialCharacterMet() throws {
        XCTAssertTrue(PasswordCriteria.specialCharacterMet("1#"))
    }
    func testSpecialCharacterNotMet() throws {
        XCTAssertFalse(PasswordCriteria.specialCharacterMet("aewiurj123vfSEF"))
    }
}
