//
//  SettingsViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class SettingsViewController: UIViewController {
    var domainModel: SettingsDomainModel!
    
    private lazy var embedController: UIHostingController<SettingsView> = {
        let viewModel = SettingsViewModel(onTapContinue: domainModel.onTapContinue)
        let controller = UIHostingController(rootView: SettingsView(viewModel: viewModel))
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
