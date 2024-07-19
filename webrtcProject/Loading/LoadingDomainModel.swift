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
    var cancallable: Cancellable?
    private let authManager: AuthManagerProtocol

    init(
        router: WeakRouter<LoadingRoute>,
        authManager: AuthManagerProtocol,
        remoteConfigManager: RemoteConfigManagerProtocol
    ) {
        self.router = router
        self.remoteConfigManager = remoteConfigManager
        self.authManager = authManager
        fetchConfig()
    }

    func fetchConfig() {
        cancallable = remoteConfigManager.fetchConfig()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] _ in
                    guard let self else { return }
                    if self.authManager.isLoggedIn {
                        self.router.trigger(.openHome)
                    } else {
                        self.router.trigger(.openOnboarding())
                    }
                }
            )
    }
}
