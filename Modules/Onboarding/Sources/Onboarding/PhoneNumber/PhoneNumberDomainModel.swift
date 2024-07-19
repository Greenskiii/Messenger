//
//  PhoneNumberDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine
import CommonLogic

enum PhoneNumberError {
    case none
    case verifyNumber
}

final class PhoneNumberDomainModel {
    private let router: WeakRouter<PhoneNumberRoute>
    private let remoteConfigManager: RemoteConfigManagerProtocol
    private let authManager: AuthManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    let onTapContinue = PassthroughSubject<String, Never>()
    var countryNumbersConfig: [CountryInfo] = []

    @Published var error: PhoneNumberError = .none

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
                self?.verifyPhoneNumber(phoneNumber)
            }
            .store(in: &subscriptions)
    }

    private func verifyPhoneNumber(_ phoneNumber: String) {
        authManager.verifyPhoneNumber(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { [weak self] completion in
                self?.error = .verifyNumber
            }, receiveValue: { [weak self] _ in
                self?.router.trigger(.openPhoneVerification)
            })
            .store(in: &subscriptions)
    }
}
