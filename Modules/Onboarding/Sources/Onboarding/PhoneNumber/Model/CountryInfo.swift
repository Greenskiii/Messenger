//
//  CountryInfo.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 29.05.2024.
//

import Foundation

struct CountryInfo: Codable, Identifiable {
    let flag: String
    let code: String
    let pattern: String
    let dialCode: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case flag
        case code
        case pattern
        case name
        case dialCode = "dial_code"
    }
    
    var id: String {
        return dialCode
    }
}
