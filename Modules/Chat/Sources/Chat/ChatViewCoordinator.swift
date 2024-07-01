//
//  ChatCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit

public enum ChatRoute: Route {
    case openPhoneNumber
}

public final class ChatCoordinator: ViewCoordinator<ChatRoute> {
    private let nextRouteHandler: (ChatRoute) -> Void

    public init(
        nextRouteHandler: @escaping (ChatRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        let viewController = ChatViewController()
        
        super.init(rootViewController: viewController)
        let domainModel = ChatDomainModel(
            router: weakRouter
        )
        viewController.domainModel = domainModel
    }
    
    override public func prepareTransition(for route: ChatRoute) -> TransitionType {
        nextRouteHandler(route)
        return .none()
    }
}
