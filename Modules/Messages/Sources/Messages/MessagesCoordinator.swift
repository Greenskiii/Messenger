//
//  MessagesCoordinator.swift
//
//
//  Created by Алексей Даневич on 26.07.2024.
//

import XCoordinator

public enum MessagesRoute: Route {
    case openUserSearch
}

public final class MessagesCoordinator: ViewCoordinator<MessagesRoute> {
    private let nextRouteHandler: (MessagesRoute) -> Void

    public init(
        nextRouteHandler: @escaping (MessagesRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = MessagesViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = MessagesDomainModel(
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }

    override public func prepareTransition(for route: MessagesRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
