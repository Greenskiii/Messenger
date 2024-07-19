//
//  UserSearchView.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import SwiftUI

struct UserSearchView: View {
    @ObservedObject var viewModel: UserSearchViewModel
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.searchText)
            ScrollView {
                ForEach(viewModel.users) { user in
                    VStack {
                        UserCellView(
                            user: user,
                            secondaryInfo: user.phoneNumber,
                            shouldShowPlusButton: true,
                            onTapPlusButton: viewModel.onAddContact
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

//#Preview {
//    UserSearchView()
//}
