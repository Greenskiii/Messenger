//
//  HomeViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import Combine
import FirebaseAuth

final class HomeViewModel {
    let onTapContinue: PassthroughSubject<Void, Never>
    let user: User?

    init(
        user: User?,
        onTapContinue: PassthroughSubject<Void, Never>
    ) {
        self.user = user
        self.onTapContinue = onTapContinue
    }
}
