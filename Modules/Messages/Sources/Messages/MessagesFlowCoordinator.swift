//
//  MessagesFlowCoordinator.swift.swift
//
//
//  Created by Алексей Даневич on 26.07.2024.
//

import XCoordinator
import UIKit

public enum MessagesFlowRoute: Route {
    case openMessages
}

public final class MessagesFlowCoordinator: NavigationCoordinator<MessagesFlowRoute> {
    private let nextRouteHandler: (MessagesFlowRoute) -> Void

    public init(
        navigationController: UINavigationController,
        nextRouteHandler: @escaping (MessagesFlowRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        super.init(rootViewController: navigationController, initialRoute: nil)
    }

    override public func prepareTransition(for route: MessagesFlowRoute) -> TransitionType {
        switch route {
        case .openMessages:
            let coordinator = MessagesCoordinator { _ in}
            return .push(coordinator)
        }
    }
}

