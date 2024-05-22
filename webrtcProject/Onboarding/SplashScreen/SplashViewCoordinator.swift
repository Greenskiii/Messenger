//
//  SplashViewCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit

enum SplashRoute: Route {
    case openPhoneNumber
}

class SplashViewCoordinator: ViewCoordinator<SplashRoute> {
    private let nextRouteHandler: (SplashRoute) -> Void

    init(nextRouteHandler: @escaping (SplashRoute) -> Void) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = SplashViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = SplashDomainModel(router: weakRouter)
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: SplashRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
