//
//  UserSearchViewController.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class UserSearchViewController: UIViewController {
    var domainModel: UserSearchDomainModel!
    
    private lazy var embedController: UIHostingController<UserSearchView> = {
        let viewModel = UserSearchViewModel(
            usersPublisher: domainModel.usersPublisher,
            onAddContact: domainModel.onAddContact,
            onSearchUsers: domainModel.onSearchUsers
        )
        let controller = UIHostingController(rootView: UserSearchView(viewModel: viewModel))
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
