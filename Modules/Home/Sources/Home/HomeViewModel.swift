//
//  HomeViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import Combine

final class HomeViewModel {
    let onTapContinue: PassthroughSubject<Void, Never>

    init(
        onTapContinue: PassthroughSubject<Void, Never>
    ) {
        self.onTapContinue = onTapContinue
    }
}
