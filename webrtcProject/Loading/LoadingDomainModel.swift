//
//  LoadingDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import CommonLogic
import Onboarding

final class LoadingDomainModel {
    private let router: WeakRouter<LoadingRoute>
    private let remoteConfigManager: RemoteConfigManagerProtocol
    private let profileManager: ProfileManagerProtocol

    init(
        router: WeakRouter<LoadingRoute>,
        profileManager: ProfileManagerProtocol,
        remoteConfigManager: RemoteConfigManagerProtocol
    ) {
        self.router = router
        self.remoteConfigManager = remoteConfigManager
        self.profileManager = profileManager
        fetchConfig()
    }

    func fetchConfig() {
        remoteConfigManager.fetchConfig() { [weak self] _ in
            if let currentUser = self?.profileManager.currentUser {
                self?.router.trigger(currentUser.displayName == nil ? .openOnboarding(.openProfileInfo) : .openHome)
            } else {
                self?.router.trigger(.openOnboarding())
            }
        }
    }
}
