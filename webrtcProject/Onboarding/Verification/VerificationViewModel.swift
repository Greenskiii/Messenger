//
//  VerificationViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import SwiftUI
import Combine

final class VerificationViewModel: ObservableObject {
    @Published var code = ""
    let phoneNumber: String
    let onTapResendButton: PassthroughSubject<Void, Never>
    let onSendCode: PassthroughSubject<String, Never>

    init(
        phoneNumber: String,
        onSendCode: PassthroughSubject<String, Never>,
        onTapResendButton: PassthroughSubject<Void, Never>
    ) {
        self.phoneNumber = phoneNumber
        self.onTapResendButton = onTapResendButton
        self.onSendCode = onSendCode
    }
}
