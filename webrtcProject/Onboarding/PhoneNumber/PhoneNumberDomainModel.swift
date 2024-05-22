//
//  PhoneNumberDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine

final class PhoneNumberDomainModel {
    private let router: WeakRouter<PhoneNumberRoute>
    private let remoteConfigManager: RemoteConfigManagerProtocol
    private let authManager: AuthManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    let onTapContinue = PassthroughSubject<String, Never>()
    var countryNumbersConfig: [CountryInfo] = []
    
    init(
        router: WeakRouter<PhoneNumberRoute>,
        authManager: AuthManagerProtocol,
        remoteConfigManager: RemoteConfigManagerProtocol
    ) {
        self.router = router
        self.remoteConfigManager = remoteConfigManager
        self.authManager = authManager
        
        self.countryNumbersConfig = remoteConfigManager.getValue(forKey: RemoteConfigManager.Keys.сountryNumbers, type: [CountryInfo].self) ?? []
        
        onTapContinue
            .sink { [weak self] phoneNumber in
                self?.authManager.verifyPhoneNumber(phoneNumber: phoneNumber) { success in
                    if success {
                        self?.router.trigger(.openPhoneVerification)
                    } else {
                        print("Show error")
                    }
                }
            }
            .store(in: &subscriptions)
    }
}

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
