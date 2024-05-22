//
//  SplashViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI

final class SplashViewController: UIViewController {
    
    var domainModel: SplashDomainModel!
    
    private lazy var embedController: UIHostingController<SplashView> = {
        let viewModel = SplashViewModel(onTapContinue: domainModel.onTapContinue)
        let controller = UIHostingController(rootView: SplashView(viewModel: viewModel))
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        add(childViewController: embedController, to: view)
    }
}

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
