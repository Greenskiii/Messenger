//
//  LoadingDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import XCoordinator
import CommonLogic
import Onboarding
import Combine

final class LoadingDomainModel {
    private let router: WeakRouter<LoadingRoute>
    private let remoteConfigManager: RemoteConfigManagerProtocol
    @Published private var user: User? = nil
    var cancallable: Cancellable?

    init(
        router: WeakRouter<LoadingRoute>,
        authManager: AuthManagerProtocol,
        remoteConfigManager: RemoteConfigManagerProtocol
    ) {
        self.router = router
        self.remoteConfigManager = remoteConfigManager
        authManager.currentUserPublisher
            .assign(to: &self.$user)
        fetchConfig()
    }

    func fetchConfig() {
        cancallable = remoteConfigManager.fetchConfig()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    if let currentUser = self?.user {
                        self?.router.trigger(currentUser.name == nil ? .openOnboarding(.openProfileInfo) : .openHome)
                    } else {
                        self?.router.trigger(.openOnboarding())
                    }
                }
            )
    }
}
