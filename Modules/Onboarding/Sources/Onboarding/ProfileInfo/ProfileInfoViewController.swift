//
//  ProfileInfoViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class ProfileInfoViewController: UIViewController {
    var domainModel: ProfileInfoDomainModel!
    
    private lazy var embedController: UIHostingController<ProfileInfoView> = {
        let viewModel = ProfileInfoViewModel(onTapSave: domainModel.onTapSave)
        let controller = UIHostingController(rootView: ProfileInfoView(viewModel: viewModel))
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
