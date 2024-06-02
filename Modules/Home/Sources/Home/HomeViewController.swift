//
//  HomeViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class HomeViewController: UIViewController {
    var domainModel: HomeDomainModel!
    
    private lazy var embedController: UIHostingController<HomeView> = {
        let viewModel = HomeViewModel(user: domainModel.user, onTapContinue: domainModel.onTapContinue)
        let controller = UIHostingController(rootView: HomeView(viewModel: viewModel))
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
