//
//  UIViewController + add.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 29.05.2024.
//

import UIKit

public extension UIViewController {
    func add(
        childViewController viewController: UIViewController,
        to contentView: UIView,
        shouldIgnoreSafeArea: Bool = true
    ) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(
                equalTo: shouldIgnoreSafeArea ? contentView.topAnchor : contentView.safeAreaLayoutGuide.topAnchor
            ),
            viewController.view.bottomAnchor.constraint(
                equalTo: shouldIgnoreSafeArea ? contentView.bottomAnchor : contentView.safeAreaLayoutGuide.bottomAnchor
            )
        ])
        viewController.didMove(toParent: self)
    }
}
