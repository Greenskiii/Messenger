//
//  PhoneNumberCoordinator.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic

enum PhoneNumberRoute: Route {
    case openPhoneVerification
}

final class PhoneNumberCoordinator: ViewCoordinator<PhoneNumberRoute> {
    private let nextRouteHandler: (PhoneNumberRoute) -> Void

    init(remoteConfigManager: RemoteConfigManagerProtocol,
         authManager: AuthManagerProtocol,
         nextRouteHandler: @escaping (PhoneNumberRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = PhoneNumberViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = PhoneNumberDomainModel(
            router: weakRouter,
            authManager: authManager,
            remoteConfigManager: remoteConfigManager
        )
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: PhoneNumberRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}

