//
//  PhoneNumberViewController.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import UIKit
import SwiftUI

final class PhoneNumberViewController: UIViewController {
    var domainModel: PhoneNumberDomainModel!
    
    private lazy var embedController: UIHostingController<PhoneNumberView> = {
        let viewModel = PhoneNumberViewModel(
            countryNumbersConfig: domainModel.countryNumbersConfig,
            onTapContinue: domainModel.onTapContinue
        )
        let controller = UIHostingController(rootView: PhoneNumberView(viewModel: viewModel))
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

