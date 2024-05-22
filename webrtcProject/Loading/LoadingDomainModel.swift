//
//  LoadingDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator

final class LoadingDomainModel {
    private let router: WeakRouter<LoadingRoute>
    private let remoteConfigManager: RemoteConfigManagerProtocol

    init(
        router: WeakRouter<LoadingRoute>,
        remoteConfigManager: RemoteConfigManagerProtocol
    ) {
        self.router = router
        self.remoteConfigManager = remoteConfigManager
        fetchConfig()
    }

    func fetchConfig() {
        remoteConfigManager.fetchConfig() { [weak self] _ in
            self?.router.trigger(.openOnboarding)
        }
    }
}
