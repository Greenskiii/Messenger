//
//  ContactsViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Foundation
import Combine
import CommonLogic

final class ContactsViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    let onTapAddContact: PassthroughSubject<Void, Never>
    let onTapContact: PassthroughSubject<Void, Never>
    let onViewWillAppear: PassthroughSubject<Void, Never>
    @Published var searchText: String = ""
    @Published var users: [User]?

    init(
        users: AnyPublisher<[User]?, Never>,
        onTapAddContact: PassthroughSubject<Void, Never>,
        onTapContact: PassthroughSubject<Void, Never>,
        onViewWillAppear: PassthroughSubject<Void, Never>
    ) {
        self.onTapAddContact = onTapAddContact
        self.onTapContact = onTapContact
        self.onViewWillAppear = onViewWillAppear

        $searchText
            .combineLatest(users)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text, users in
                if text.isEmpty {
                    self?.users = users ?? []
                } else {
                    self?.users = users?.filter { $0.name.contains(text) } ?? []
                }
            }
            .store(in: &subscriptions)
    }
}
