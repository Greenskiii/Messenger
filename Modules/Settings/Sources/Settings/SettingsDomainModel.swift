//
//  SettingsDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine

final class SettingsDomainModel {
    private let router: WeakRouter<SettingsRoute>
    private var subscriptions = Set<AnyCancellable>()
    let onTapContinue = PassthroughSubject<Void, Never>()

    init(
        router: WeakRouter<SettingsRoute>
    ) {
        self.router = router

        onTapContinue
            .sink { [weak self] _ in
                self?.router.trigger(.openPhoneNumber)
            }
            .store(in: &subscriptions)
    }
}
