//
//  ContactsViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class ContactsViewController: UIViewController {
    var domainModel: ContactsDomainModel!
    
    private lazy var embedController: UIHostingController<ContactsView> = {
        
        let viewModel = ContactsViewModel(
            users: domainModel.currentUser.map(\.?.contacts).eraseToAnyPublisher(),
            onTapAddContact: domainModel.onTapAddContact,
            onTapContact: domainModel.onTapContact, 
            onViewWillAppear: domainModel.onViewWillAppear
        )
        let controller = UIHostingController(rootView: ContactsView(viewModel: viewModel))
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.setTabBarHidden(false, animated: false)
    }

    private func configureUI() {
        add(childViewController: embedController, to: view)
    }
}
