//
//  AppCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit

enum AppRoute: Route {
    case loading
    case onboarding
    case home
    case flowFinished
}
private class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
    }
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    private let remoteConfigManager = RemoteConfigManager()
    private let authManager = AuthManager()

    init(window: UIWindow) {
        let appNavigationController = AppNavigationController()
        super.init(rootViewController: appNavigationController, initialRoute: .loading)
        setRoot(for: window)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .loading:
            let coordinator = LoadingCoordinator(
                remoteConfigManager: remoteConfigManager
            ) { [weak self] route in
                switch route {
                case .openOnboarding:
                    self?.trigger(.onboarding)
                case .openHome:
                    self?.trigger(.home)
                }
            }
            return .set([coordinator])
        case .onboarding:
            let coordinator = OnboardingCoordinator(
                remoteConfigManager: remoteConfigManager,
                authManager: authManager,
                initialRoute: .openSplash
            ) { [weak self] route in
                if route == .flowFinished {
                    self?.trigger(.home)
                }
            }
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            return .present(coordinator)
        case .home:
            return .none()
        case .flowFinished:
            return .none()
        }
    }
}
