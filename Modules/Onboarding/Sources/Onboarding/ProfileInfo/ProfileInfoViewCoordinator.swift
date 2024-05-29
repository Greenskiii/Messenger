//
//  ProfileInfoViewCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic

enum ProfileInfoRoute: Route {
    case openHome
}

class ProfileInfoViewCoordinator: ViewCoordinator<ProfileInfoRoute> {
    private let nextRouteHandler: (ProfileInfoRoute) -> Void

    init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (ProfileInfoRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = ProfileInfoViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = ProfileInfoDomainModel(
            profileManager: profileManager,
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }
    
    override func prepareTransition(for route: ProfileInfoRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
