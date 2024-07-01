//
//  ChatDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import XCoordinator
import Combine

final class ChatDomainModel {
    private let router: WeakRouter<ChatRoute>
    private var subscriptions = Set<AnyCancellable>()
    let onTapContinue = PassthroughSubject<Void, Never>()

    init(
        router: WeakRouter<ChatRoute>
    ) {
        self.router = router

        onTapContinue
            .sink { [weak self] _ in
                self?.router.trigger(.openPhoneNumber)
            }
            .store(in: &subscriptions)
    }
}
