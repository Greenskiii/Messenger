//
//  ProfileInfoViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import SwiftUI
import Combine

final class ProfileInfoViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var avatarImage: UIImage?
    @Published var showingImagePicker: Bool = false
    let onTapSave = PassthroughSubject<Void, Never>()
    private var subscriptions = Set<AnyCancellable>()

    init(onTapSave: PassthroughSubject<(String, Data?), Never>) {
        self.onTapSave
            .sink { [weak self] _ in
                guard let self, !firstName.isEmpty else { return }
                onTapSave.send(("\(self.firstName) \(self.lastName)", avatarImage?.jpegData(compressionQuality: 1)))
        }
            .store(in: &subscriptions)
    }
}

