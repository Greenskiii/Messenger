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
import Contacts

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

    private lazy var mainTabBarCoordinator: MainTabBarCoordinator = {
        MainTabBarCoordinator(profileManager: profileManager) { [weak self] route in
            self?.trigger(.flowFinished)
        }
    }()
    init(window: UIWindow) {
        self.profileManager = ProfileManager()
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
                    DispatchQueue.main.async {
                        self?.trigger(.flowFinished) {
                            self?.trigger(.home)
                        }
                    }
                }
            }
            coordinator.rootViewController.modalPresentationStyle = .fullScreen
            return .present(coordinator)
        case .home:
            return .set([mainTabBarCoordinator])
        case .flowFinished:
            return .dismiss()
        }
    }
}
