//
//  UserSearchCoordinator.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import XCoordinator
import CommonLogic

enum UserSearchRoute: Route {
    case dismiss
}

final class UserSearchCoordinator: ViewCoordinator<UserSearchRoute> {
    private let nextRouteHandler: (UserSearchRoute) -> Void

    init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (UserSearchRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = UserSearchViewController()
        super.init(rootViewController: viewController)
        let domainModel = UserSearchDomainModel(profileManager: profileManager, router: self.weakRouter)
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: UserSearchRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
