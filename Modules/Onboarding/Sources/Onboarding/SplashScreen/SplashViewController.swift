//
//  SplashViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

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
