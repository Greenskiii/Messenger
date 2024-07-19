//
//  TabBarController.swift
//
//
//  Created by Алексей Даневич on 09.06.2024.
//

import UIKit
import Design

final class TabBarController: UITabBarController {
    private var tabs: [Tab]

    override var selectedViewController: UIViewController? {
        didSet {
            updateTabBarItems()
        }
    }

    init(tabs: [Tab]) {
        self.tabs = tabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTabBarItems()
    }

    private func setUp() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = Asset.Colors.tabBarBackground.color
        tabBar.tintColor = Asset.Colors.tabBarTint.color
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor.black],
            for: .selected
        )
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -20)
    }

    private func updateTabBarItems() {
        guard let viewControllers = viewControllers else { return }
        for i in viewControllers.indices {
            let viewController = viewControllers[i]
            
            if viewController == selectedViewController {
                viewController.tabBarItem.title = tabs[i].title
                viewController.tabBarItem.selectedImage = nil
                viewController.tabBarItem.image = nil
                
            } else {
                viewController.tabBarItem.title = nil
                viewController.tabBarItem.selectedImage = tabs[i].image
                viewController.tabBarItem.image = tabs[i].image
            }
        }
    }

    private func createMultilineLabel(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
