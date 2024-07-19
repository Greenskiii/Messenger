//
//  ContactsCoordinator.swift
//  
//
//  Created by Алексей Даневич on 19.07.2024.
//

import XCoordinator
import CommonLogic

public enum ContactsRoute: Route {
    case openUserSearch
    case openMessages
}

public final class ContactsCoordinator: ViewCoordinator<ContactsRoute> {
    private let nextRouteHandler: (ContactsRoute) -> Void

    public init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (ContactsRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = ContactsViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = ContactsDomainModel(
            profileManager: profileManager,
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }

    override public func prepareTransition(for route: ContactsRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
