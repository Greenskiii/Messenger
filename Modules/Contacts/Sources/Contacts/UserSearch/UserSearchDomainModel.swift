//
//  UserSearchDomainModel.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import Foundation
import XCoordinator
import Combine
import CommonLogic

final class UserSearchDomainModel {
    private let router: WeakRouter<UserSearchRoute>
    private var subscriptions = Set<AnyCancellable>()
    var usersPublisher: AnyPublisher<[User], Never> {
        usersRelay.eraseToAnyPublisher()
    }
    private let profileManager: ProfileManagerProtocol
    
    private let usersRelay = PassthroughSubject<[User], Never>()
    let onAddContact = PassthroughSubject<String, Never>()
    let onSearchUsers = PassthroughSubject<String, Never>()

    init(
        profileManager: ProfileManagerProtocol,
        router: WeakRouter<UserSearchRoute>
    ) {
        self.profileManager = profileManager
        self.router = router

        onAddContact
            .sink { [weak self] id in
                self?.addContact(with: id)
            }
            .store(in: &subscriptions)
        
        onSearchUsers
            .sink { [weak self] phoneNumber in
                self?.getUsers(phoneNumber: phoneNumber)
            }
            .store(in: &subscriptions)
    }

    func getUsers(phoneNumber: String) {
        profileManager.getUsers(with: phoneNumber)
            .sink { completion in
            } receiveValue: { [weak self] users in
                DispatchQueue.main.async {
                    self?.usersRelay.send(users.filter { $0.id != self?.profileManager.userId })
                }
            }
            .store(in: &subscriptions)
    }

    func addContact(with id: String) {
        profileManager.addContact(with: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("")
            } receiveValue: { [weak self] void in
                self?.router.trigger(.dismiss)
            }
            .store(in: &subscriptions)
    }
}
