//
//  LoadingCoordinator.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import XCoordinator
import Onboarding
import CommonLogic

enum LoadingRoute: Route {
    case openOnboarding(_ initialRoute: OnboardingRoute = .openSplash)
    case openHome
}

class LoadingCoordinator: ViewCoordinator<LoadingRoute> {
    private let nextRouteHandler: (LoadingRoute) -> Void

    init(
        profileManager: ProfileManagerProtocol,
        remoteConfigManager: RemoteConfigManagerProtocol,
        nextRouteHandler: @escaping (LoadingRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        
        let viewController = LoadingViewController()
        
        super.init(rootViewController: viewController)
        
        let domainModel = LoadingDomainModel(
            router: weakRouter,
            profileManager: profileManager,
            remoteConfigManager: remoteConfigManager
        )
        viewController.domainModel = domainModel
    }

    override func prepareTransition(for route: LoadingRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
