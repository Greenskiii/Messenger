//
//  PhoneNumberFormatter.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 29.05.2024.
//

import Foundation

public struct PhoneNumberFormatter {
    public static let shared = PhoneNumberFormatter()

    public func formatPhoneNumber(_ number: String, withPattern pattern: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex
        
        for char in pattern where startIndex < endIndex {
            if char == "#" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        return result
    }
}
