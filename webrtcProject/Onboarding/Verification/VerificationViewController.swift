//
//  VerificationViewController.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import UIKit
import SwiftUI
import Combine

final class VerificationViewController: UIViewController {
    var domainModel: VerificationDomainModel!
    private var subscriptions = Set<AnyCancellable>()

    private lazy var embedController: UIHostingController<VerificationView> = {
        let viewModel = VerificationViewModel(
            phoneNumber: domainModel.phoneNumber, 
            onSendCode: domainModel.onSendCode,
            onTapResendButton: domainModel.onTapResendButton
        )
        let controller = UIHostingController(rootView: VerificationView(viewModel: viewModel))
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        domainModel.onHideKeyboard
            .sink { [weak self] _ in
                self?.hideKeyboard()
            }
            .store(in: &subscriptions)
    }

    private func configureUI() {
        add(childViewController: embedController, to: view)
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(barButtonItemTapped)
        )
        navigationItem.leftBarButtonItem = barButtonItem
        navigationController?.navigationBar.tintColor = .backButton
    }

    @objc private func barButtonItemTapped() {
        domainModel.onTapBackButton.send()
     }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

