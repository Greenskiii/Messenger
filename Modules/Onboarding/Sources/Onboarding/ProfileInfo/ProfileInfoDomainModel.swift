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

enum ProfileInfoError {
    case none
    case saveUserInfo
}

final class ProfileInfoDomainModel {
    private let router: WeakRouter<ProfileInfoRoute>
    private let profileManager: ProfileManagerProtocol
    private var subscriptions = Set<AnyCancellable>()
    @Published var error: ProfileInfoError = .none

    let onTapSave = PassthroughSubject<(String, Data?), Never>()

    init(
        profileManager: ProfileManagerProtocol,
        router: WeakRouter<ProfileInfoRoute>
    ) {
        self.router = router
        self.profileManager = profileManager

        onTapSave
            .sink { [weak self] (name, image) in
                self?.saveUserInfo(name, imageData: image)
            }
            .store(in: &subscriptions)
    }

    private func saveUserInfo(_ name: String, imageData: Data? = nil) {
        profileManager.updateUserInfo(image: imageData, name: name)
            .sink { [weak self] _ in
                self?.error = .saveUserInfo
            } receiveValue: { [weak self] _ in
                self?.router.trigger(.openHome)
            }
            .store(in: &subscriptions)
    }
}
