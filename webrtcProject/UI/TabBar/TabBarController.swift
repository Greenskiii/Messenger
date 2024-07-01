//
//  TabBarController.swift
//
//
//  Created by Алексей Даневич on 09.06.2024.
//

import UIKit
import Design

public final class TabBarController: UITabBarController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Asset.Colors.tabBarBackground.color
        tabBar.tintColor = Asset.Colors.tabBarTint.color
    }
}
