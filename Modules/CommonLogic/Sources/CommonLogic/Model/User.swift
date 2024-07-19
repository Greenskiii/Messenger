//
//  User.swift
//
//
//  Created by Алексей Даневич on 31.05.2024.
//

import Foundation

public struct User: Codable, Identifiable {
    public let name: String
    public let imageURL: String
    public let phoneNumber: String
    public let userId: String
    public var friends: [String]
    public var status: String
    public var contacts: [User]?
    
    public var id: String {
        return userId
    }
    
    public var firstLetters: String {
        let words = name.split(separator: " ").prefix(2)
        let firstLetters = words.map { $0.first ?? Character("") }
        return String(firstLetters)
    }

    public var isOnline: Bool {
        status == "online"
    }
}
