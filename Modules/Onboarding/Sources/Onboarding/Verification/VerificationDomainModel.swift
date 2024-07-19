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
import CommonLogic

enum VerificationError {
    case none
    case verification
    case resend
}

final class VerificationDomainModel {
    private let router: WeakRouter<VerificationRoute>
    private let authManager: AuthManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    let onTapBackButton = PassthroughSubject<Void, Never>()
    let onTapResendButton = PassthroughSubject<Void, Never>()
    let onSendCode = PassthroughSubject<String, Never>()
    let onHideKeyboard = PassthroughSubject<Void, Never>()

    @Published var error: VerificationError = .none
    @Published var phoneNumber: String = ""

    init(
        router: WeakRouter<VerificationRoute>,
        authManager: AuthManagerProtocol
    ) {
        self.router = router
        self.authManager = authManager

        authManager.phoneNumberPublisher
            .assign(to: &self.$phoneNumber)

        onSendCode
            .sink { [weak self] code in
                self?.onHideKeyboard.send()
                self?.verifyCode(code)
            }
            .store(in: &subscriptions)

        onTapBackButton
            .sink { [weak self] _ in
                self?.router.trigger(.dismissChild)
            }
            .store(in: &subscriptions)

        onTapResendButton
            .sink { [weak self] _ in
                self?.resendCode()
            }
            .store(in: &subscriptions)
    }

    private func verifyCode(_ code: String) {
        authManager.signIn(verificationCode: code)
            .sink(receiveCompletion: { [weak self] _ in
                self?.error = .verification
            }, receiveValue: { [weak self] name in
                self?.router.trigger(name == nil ? .openProfileInfo : .openHome)
            })
            .store(in: &subscriptions)
    }

    private func resendCode() {
        authManager.verifyPhoneNumber(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { [weak self] _ in
                self?.error = .resend
            }, receiveValue: { _ in })
            .store(in: &subscriptions)
    }
}
