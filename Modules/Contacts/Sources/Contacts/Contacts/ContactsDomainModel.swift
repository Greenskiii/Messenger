//
//  ContactsDomainModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import XCoordinator
import Combine
import CommonLogic

final class ContactsDomainModel {
    var currentUser: AnyPublisher<User?, Never>
    private let router: WeakRouter<ContactsRoute>
    private var subscriptions = Set<AnyCancellable>()
    let onTapAddContact = PassthroughSubject<Void, Never>()
    let onTapContact = PassthroughSubject<Void, Never>()
    let onViewWillAppear = PassthroughSubject<Void, Never>()

    init(
        profileManager: ProfileManagerProtocol,
        router: WeakRouter<ContactsRoute>
    ) {
        self.router = router
        self.currentUser = profileManager.currentUserPublisher

        onTapAddContact
            .sink { [weak self] _ in
                self?.router.trigger(.openUserSearch)
            }
            .store(in: &subscriptions)

        onTapContact
            .sink { [weak self] _ in
                self?.router.trigger(.openMessages)
            }
            .store(in: &subscriptions)

        onViewWillAppear
            .sink { _ in
                profileManager.getUserInfo()
            }
            .store(in: &subscriptions)

    }
}
