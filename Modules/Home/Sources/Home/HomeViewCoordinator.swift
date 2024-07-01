//
//  HomeCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit

public enum HomeRoute: Route {
    case openPhoneNumber
}

public final class HomeCoordinator: ViewCoordinator<HomeRoute> {
    private let nextRouteHandler: (HomeRoute) -> Void

    public init(
        nextRouteHandler: @escaping (HomeRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = HomeViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = HomeDomainModel(
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }
    
    override public func prepareTransition(for route: HomeRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
