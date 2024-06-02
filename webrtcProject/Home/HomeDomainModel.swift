//
//  HomeDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine
import CommonLogic

final class HomeDomainModel {
    private let router: WeakRouter<HomeRoute>
    private var subscriptions = Set<AnyCancellable>()
    let onTapContinue = PassthroughSubject<Void, Never>()
    @Published var user: User? = nil

    init(
        router: WeakRouter<HomeRoute>,
        profileManager: ProfileManagerProtocol
    ) {
        self.router = router

        profileManager.currentUserPublisher
            .assign(to: &self.$user)

        onTapContinue
            .sink { [weak self] _ in
                self?.router.trigger(.openPhoneNumber)
            }
            .store(in: &subscriptions)
    }
}
