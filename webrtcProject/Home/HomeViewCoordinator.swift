//
//  HomeCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic

enum HomeRoute: Route {
    case openPhoneNumber
}

class HomeCoordinator: ViewCoordinator<HomeRoute> {
    private let nextRouteHandler: (HomeRoute) -> Void

    init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (HomeRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = HomeViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = HomeDomainModel(
            router: weakRouter,
            profileManager: profileManager
        )
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: HomeRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
