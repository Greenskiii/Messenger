//
//  UserSearchViewModel.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import SwiftUI
import Combine
import CommonLogic

final class UserSearchViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    @Published var searchText: String = ""
    @Published var users: [User] = []
    let onSearchUsers: PassthroughSubject<String, Never>
    let onAddContact: PassthroughSubject<String, Never>
    var searchTextPublisher: AnyPublisher<String, Never> {
        $searchText.eraseToAnyPublisher()
    }
    
    init(
        usersPublisher: AnyPublisher<[User], Never>,
        onAddContact: PassthroughSubject<String, Never>,
        onSearchUsers: PassthroughSubject<String, Never>
    ) {
        self.onSearchUsers = onSearchUsers
        self.onAddContact = onAddContact

        usersPublisher
            .assign(to: &self.$users)
        
        searchTextPublisher
            .sink { [weak self] text in
                guard text.count > 3 else {
                    return
                }
                self?.onSearchUsers.send(text.replacingOccurrences(of: "+", with: ""))
            }
            .store(in: &subscriptions)
    }
}
