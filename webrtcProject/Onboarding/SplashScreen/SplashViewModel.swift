//
//  SplashViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import Combine

final class SplashViewModel {
    let onTapContinue: PassthroughSubject<Void, Never>

    init(onTapContinue: PassthroughSubject<Void, Never>) {
        self.onTapContinue = onTapContinue
    }
}
