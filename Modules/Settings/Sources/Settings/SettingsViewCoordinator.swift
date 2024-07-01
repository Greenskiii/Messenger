//
//  SettingsCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit

public enum SettingsRoute: Route {
    case openPhoneNumber
}

public final class SettingsCoordinator: ViewCoordinator<SettingsRoute> {
    private let nextRouteHandler: (SettingsRoute) -> Void

    public init(
        nextRouteHandler: @escaping (SettingsRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = SettingsViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = SettingsDomainModel(
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }
    
    override public func prepareTransition(for route: SettingsRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
