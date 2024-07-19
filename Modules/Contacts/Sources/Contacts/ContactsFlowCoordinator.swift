//
//  ContactsFlowCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic
import Messages

public enum ContactsFlowRoute: Route {
    case initial
    case openUserSearch
    case openMessages
    case dismiss
}

public final class ContactsFlowCoordinator: NavigationCoordinator<ContactsFlowRoute> {
    private let profileManager: ProfileManagerProtocol
    private let nextRouteHandler: (ContactsFlowRoute) -> Void

    private var contactsCoordinator: ContactsCoordinator!

    public init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (ContactsFlowRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        self.profileManager = profileManager
        super.init(initialRoute: .initial)
    }

    override public func prepareTransition(for route: ContactsFlowRoute) -> NavigationTransition {
        switch route {
        case .initial:
            contactsCoordinator = ContactsCoordinator(profileManager: profileManager) { [weak self] route in
                switch route {
                case .openUserSearch:
                    self?.trigger(.openUserSearch)
                case .openMessages:
                    self?.trigger(.openMessages)
                }
            }
            return .set([contactsCoordinator])
        case .openUserSearch:
            let coordinator = UserSearchCoordinator(profileManager: profileManager) { [weak self] route in
                switch route {
                case .dismiss:
                    self?.trigger(.dismiss)
                }
            }
            return .present(coordinator)
        case .openMessages:
            let coordinator = MessagesFlowCoordinator(navigationController: rootViewController) { _ in}
            addChild(coordinator)
            return .trigger(.openMessages, on: coordinator)
        case .dismiss:
            return .dismiss()
        }
    }
}
