//
//  HomeDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine
import FirebaseAuth
import CommonLogic

final class HomeDomainModel {
    private let router: WeakRouter<HomeRoute>
    private let profileManager: ProfileManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    let onTapContinue = PassthroughSubject<Void, Never>()
    var user: User? {
        profileManager.currentUser
    }

    init(
        router: WeakRouter<HomeRoute>,
        profileManager: ProfileManagerProtocol
    ) {
        self.router = router
        self.profileManager = profileManager

        onTapContinue
            .sink { [weak self] _ in
                self?.router.trigger(.openPhoneNumber)
            }
            .store(in: &subscriptions)
    }
}
