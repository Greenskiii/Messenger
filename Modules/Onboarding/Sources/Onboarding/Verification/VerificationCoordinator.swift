//
//  VerificationCoordinator.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic

enum VerificationRoute: Route {
    case openProfileInfo
    case dismissChild
    case openHome
}

final class VerificationCoordinator: ViewCoordinator<VerificationRoute> {
    private let nextRouteHandler: (VerificationRoute) -> Void

    init(authManager: AuthManagerProtocol,
         nextRouteHandler: @escaping (VerificationRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = VerificationViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = VerificationDomainModel(
            router: weakRouter,
            authManager: authManager
        )
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: VerificationRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}

