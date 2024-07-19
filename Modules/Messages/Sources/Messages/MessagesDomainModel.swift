//
//  MessagesDomainModel.swift
//
//
//  Created by Алексей Даневич on 26.07.2024.
//

import Foundation
import XCoordinator

final class MessagesDomainModel {
    private let router: WeakRouter<MessagesRoute>

    init(router: WeakRouter<MessagesRoute>) {
        self.router = router
    }
}
