//
//  ChatViewController.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import UIKit
import SwiftUI
import BaseUI

final class ChatViewController: UIViewController {
    var domainModel: ChatDomainModel!
    
    private lazy var embedController: UIHostingController<ChatView> = {
        let viewModel = ChatViewModel(onTapContinue: domainModel.onTapContinue)
        let controller = UIHostingController(rootView: ChatView(viewModel: viewModel))
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
