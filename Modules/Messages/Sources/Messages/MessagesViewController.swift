//
//  MessagesViewController.swift
//
//
//  Created by Алексей Даневич on 26.07.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class MessagesViewController: UIViewController {
    var domainModel: MessagesDomainModel!
    
    private lazy var embedController: UIHostingController<MessagesView> = {
        let viewModel = MessagesViewModel()
        let controller = UIHostingController(rootView: MessagesView(viewModel: viewModel))
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.setTabBarHidden(true, animated: true)
    }

    private func configureUI() {
        add(childViewController: embedController, to: view)
    }
}
