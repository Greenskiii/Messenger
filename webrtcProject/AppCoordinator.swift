//
//  AppCoordinator.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import XCoordinator
import UIKit
import CommonLogic
import Onboarding
import Home

enum AppRoute: Route {
    case loading
    case onboarding(_ initialRoute: OnboardingRoute = .openSplash)
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
    private let profileManager: ProfileManagerProtocol

    init(window: UIWindow) {
        self.profileManager = ProfileManager(currentUser: authManager.currentUserPublisher)
        let appNavigationController = AppNavigationController()
        super.init(rootViewController: appNavigationController, initialRoute: .loading)
        setRoot(for: window)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .loading:
            let coordinator = LoadingCoordinator(
                authManager: authManager,
                remoteConfigManager: remoteConfigManager
            ) { [weak self] route in
                switch route {
                case .openOnboarding(let initialRoute):
                    self?.trigger(.onboarding(initialRoute))
                case .openHome:
                    self?.trigger(.home)
                }
            }
            return .set([coordinator])
        case .onboarding(let initialRoute):
            let coordinator = OnboardingCoordinator(
                remoteConfigManager: remoteConfigManager,
                authManager: authManager,
                profileManager: profileManager,
                initialRoute: initialRoute
            ) { [weak self] route in
                if route == .openHome {
                    self?.trigger(.flowFinished) {
                        self?.trigger(.home)
                    }
                }
            }
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            return .present(coordinator)
        case .home:
            let coordinator = MainTabBarCoordinator(profileManager: profileManager) { [weak self] route in
                self?.trigger(.flowFinished)
            }
            return .set([coordinator])
        case .flowFinished:
            return .dismiss()
        }
    }
}
