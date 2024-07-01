//
//  PhoneNumberFormatterTests.swift
//  
//
//  Created by Алексей Даневич on 05.06.2024.
//

import XCTest
@testable import CommonLogic

class PhoneNumberFormatterTests: XCTestCase {

    func testFormatPhoneNumber_withBasicPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567890", withPattern: "(###) ###-####")
        XCTAssertEqual(formattedNumber, "(123) 456-7890", "Phone number should be formatted correctly.")
    }
    
    func testFormatPhoneNumber_withPartialPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567", withPattern: "(###) ###-####")
        XCTAssertEqual(formattedNumber, "(123) 456-7", "Phone number should be formatted correctly even if the input is shorter than the pattern.")
    }
    
    func testFormatPhoneNumber_withExtraDigits() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("12345678901234", withPattern: "(###) ###-####")
        XCTAssertEqual(formattedNumber, "(123) 456-7890", "Phone number should ignore extra digits beyond the pattern.")
    }
    
    func testFormatPhoneNumber_withNonNumericCharacters() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("123-456-7890", withPattern: "(###) ###-####")
        XCTAssertEqual(formattedNumber, "(123) 456-7890", "Phone number should be formatted correctly ignoring non-numeric characters.")
    }
    
    func testFormatPhoneNumber_withEmptyNumber() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("", withPattern: "(###) ###-####")
        XCTAssertEqual(formattedNumber, "", "Formatting an empty phone number should return an empty string.")
    }
    
    func testFormatPhoneNumber_withDifferentPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567890", withPattern: "###-###-####")
        XCTAssertEqual(formattedNumber, "123-456-7890", "Phone number should be formatted correctly with a different pattern.")
    }
    
    func testFormatPhoneNumber_withComplexPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567890", withPattern: "+# (###) ###-##-##")
        XCTAssertEqual(formattedNumber, "+1 (234) 567-89-0", "Phone number should be formatted correctly with a complex pattern.")
    }
    
    func testFormatPhoneNumber_withShortPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567890", withPattern: "###")
        XCTAssertEqual(formattedNumber, "123", "Phone number should be formatted correctly with a short pattern.")
    }
    
    func testFormatPhoneNumber_withNonHashPattern() {
        let formattedNumber = PhoneNumberFormatter.shared.formatPhoneNumber("1234567890", withPattern: "(***) ***-****")
        XCTAssertEqual(formattedNumber, "(***) ***-****", "Phone number should be formatted correctly even if the pattern does not contain hashes.")
    }
}
