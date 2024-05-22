//
//  OnboardingCoordinator.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import XCoordinator

enum OnboardingRoute: Route {
    case openSplash
    case openPhoneNumber
    case openPhoneVerification
    case openProfileInfo
    case flowFinished
    case dismiss
}

class OnboardingCoordinator: NavigationCoordinator<OnboardingRoute> {
    private let nextRouteHandler: (OnboardingRoute) -> Void
    private let remoteConfigManager: RemoteConfigManagerProtocol
    private let authManager: AuthManagerProtocol

    init(
        remoteConfigManager: RemoteConfigManagerProtocol,
        authManager: AuthManagerProtocol,
        initialRoute: OnboardingRoute,
        nextRouteHandler: @escaping (OnboardingRoute) -> Void
    ) {
        self.nextRouteHandler = nextRouteHandler
        self.remoteConfigManager = remoteConfigManager
        self.authManager = authManager
        super.init(initialRoute: .openSplash)
    }

    override func prepareTransition(for route: OnboardingRoute) -> NavigationTransition {
        switch route {
        case .openSplash:
            let coordinator = SplashViewCoordinator() { [weak self] route in
                if route == .openPhoneNumber {
                    self?.trigger(.openPhoneNumber)
                }
            }
            return .set([coordinator])
        case .openPhoneNumber:
            let coordinator = PhoneNumberCoordinator(
                remoteConfigManager: remoteConfigManager,
                authManager: authManager
            ) { [weak self] route in
                if route == .openPhoneVerification {
                    self?.trigger(.openPhoneVerification)
                }
            }
            return .set([coordinator])
        case .openPhoneVerification:
            let coordinator = VerificationCoordinator(
                authManager: authManager
            ) { [weak self] route in
                switch route {
                case .openProfileInfo:
                    self?.trigger(.openProfileInfo)
                case .dismissChild:
                    self?.trigger(.dismiss)
                }
            }
            return .push(coordinator)
        case .openProfileInfo:
            return .none()
        case .dismiss:
            return .pop()
        default:
            nextRouteHandler(route)
            return .none()
        }
    }
}
