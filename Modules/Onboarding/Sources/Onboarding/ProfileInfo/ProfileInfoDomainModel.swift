//
//  ProfileInfoDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine
import CommonLogic

final class ProfileInfoDomainModel {
    private let router: WeakRouter<ProfileInfoRoute>
    private let profileManager: ProfileManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    let onTapSave = PassthroughSubject<(String, Data?), Never>()

    init(
        profileManager: ProfileManagerProtocol,
        router: WeakRouter<ProfileInfoRoute>
    ) {
        self.router = router
        self.profileManager = profileManager

        onTapSave
            .sink { [weak self] (name, image) in
                guard let currentUser = self?.profileManager.currentUser else { return }
                self?.profileManager.updateUserInfo(userId: currentUser.uid, image: image, name: name) { success in
                    if success {
                        self?.router.trigger(.openHome)
                    }
                }
                
            }
            .store(in: &subscriptions)
    }
}
