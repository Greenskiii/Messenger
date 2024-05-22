//
//  VerificationDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import Foundation
import XCoordinator
import Combine
import UIKit

final class VerificationDomainModel {
    private let router: WeakRouter<VerificationRoute>
    private let authManager: AuthManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    let onTapBackButton = PassthroughSubject<Void, Never>()
    let onTapResendButton = PassthroughSubject<Void, Never>()
    let onSendCode = PassthroughSubject<String, Never>()
    let onHideKeyboard = PassthroughSubject<Void, Never>()

    var phoneNumber: String {
        authManager.phoneNumber
    }

    init(
        router: WeakRouter<VerificationRoute>,
        authManager: AuthManagerProtocol
    ) {
        self.router = router
        self.authManager = authManager

        onSendCode
            .sink { [weak self] code in
                self?.onHideKeyboard.send()
                self?.authManager.signIn(verificationCode: code) { success in
                    if success {
                        self?.router.trigger(.openProfileInfo)
                    } else {
                        print("show Error")
                    }
                }
            }
            .store(in: &subscriptions)

        onTapBackButton
            .sink { [weak self] _ in
                self?.router.trigger(.dismissChild)
            }
            .store(in: &subscriptions)

        onTapResendButton
            .sink { [weak self] _ in
                guard let self else { return }
                self.authManager.verifyPhoneNumber(phoneNumber: self.phoneNumber) { success in
                    if success {
                        
                    } else {
                        
                    }
                }
            }
            .store(in: &subscriptions)
    }
}
