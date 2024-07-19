//
//  MainTabBarCoordinator.swift
//
//
//  Created by Алексей Даневич on 09.06.2024.
//

import XCoordinator
import Contacts
import Chat
import Settings
import CommonLogic

enum TabBarRoute: Route {
    case switchToTab(Tab)
    case home
    case settings
    case chats
    case setTabs
    case dismiss
}

final class MainTabBarCoordinator: TabBarCoordinator<TabBarRoute> {
    private let profileManager: ProfileManagerProtocol
    private let nextRouteHandler: (TabBarRoute) -> Void

    private lazy var contactsFlowCoordinator: ContactsFlowCoordinator = {
        return ContactsFlowCoordinator(profileManager: profileManager) { [weak self] route in
            switch route {
            default:
                break
            }
        }
    }()
    
    private lazy var chatCoordinator: ChatCoordinator = {
        return ChatCoordinator { [weak self] route in
            switch route {
            case .openPhoneNumber:
                self?.trigger(.home)
            }
        }
    }()
    
    private lazy var settingsCoordinator: SettingsCoordinator = {
        return SettingsCoordinator { [weak self] route in
            switch route {
            case .openPhoneNumber:
                self?.trigger(.home)
            }
        }
    }()
    
    init(
        profileManager: ProfileManagerProtocol,
        nextRouteHandler: @escaping (TabBarRoute) -> Void
    ) {
        self.profileManager = profileManager
        self.nextRouteHandler = nextRouteHandler
        let tabBarController = TabBarController(tabs: Tab.allCases)
        super.init(rootViewController: tabBarController, initialRoute: .setTabs)
    }

    override func prepareTransition(for route: TabBarRoute) -> TabBarTransition {
        switch route {
        case .home:
            return chain(routes: [.dismiss, .switchToTab(.home)])
        case .settings:
            return chain(routes: [.dismiss, .switchToTab(.settings)])
        case .chats:
            return chain(routes: [.dismiss, .switchToTab(.chats)])
        case .setTabs:
            let tabs = configureTabs()
            return .set(tabs)
        case .dismiss:
            return .dismiss()
        case .switchToTab(let tab):
            return .select(coordinator(for: tab))
        }
    }

    private func configureTabs() -> [Presentable] {
        let tabs = Tab.allCases.map { tab in
            
            let coordinator = coordinator(for: tab)
            coordinator.viewController.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, selectedImage: nil)
            return coordinator
        }
        return tabs
    }
    
    private func coordinator(for tab: Tab) -> Presentable {
        switch tab {
        case .home:
            return contactsFlowCoordinator
        case .settings:
            return settingsCoordinator
        case .chats:
            return chatCoordinator
        }
    }
}

import UIKit
import Design

enum Tab: CaseIterable {
    case home
    case chats
    case settings
}

extension Tab {
    var image: UIImage {
        switch self {
        case .home:
            Asset.Icons.contactsIcon.image
        case .settings:
            Asset.Icons.moreIcon.image
        case .chats:
            Asset.Icons.chatsIcon.image
        }
    }

    var title: String {
        switch self {
        case .home:
            "Contacts\n•"
        case .settings:
            "More\n•"
        case .chats:
            "Chats\n•"
        }
    }
}
