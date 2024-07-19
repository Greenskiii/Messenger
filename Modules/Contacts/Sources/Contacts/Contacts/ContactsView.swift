//
//  ContactsView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI
import Design
import BaseUI
import CommonLogic

struct ContactsView: View {
    @ObservedObject var viewModel: ContactsViewModel
    @State var shouldShowSearch = true

    var body: some View {
        VStack {
            header
            if shouldShowSearch {
                SearchBar(text: $viewModel.searchText)
            }
            if let users = viewModel.users {
                contacts(users)
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .onAppear {
            viewModel.onViewWillAppear.send()
        }
    }

    var header: some View {
        HStack {
            Text("Contacts")
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.contactsTextSize))
            Spacer()
            Button {
                viewModel.onTapAddContact.send()
            } label: {
                Image(uiImage: Asset.Icons.plus.image)
                    .resizable()
                    .frame(
                        width: Constants.plusImageWidth,
                        height: Constants.plusImageHeight
                    )
            }
        }
        .padding(.vertical, Constants.headerPadding)
    }

    func contacts(_ users: [User]) -> some View {
        ScrollView(showsIndicators: false) {
            ForEach(users) { user in
                VStack {
                    UserCellView(user: user, secondaryInfo: user.phoneNumber)
                        .frame(height: Constants.userCellHeight)
                        .padding(.top, Constants.userCellPadding)
                        .onTapGesture {
                            viewModel.onTapContact.send()
                        }
                }
            }
        }
        .background {
            ScrollGesture {
                handleTabState($0)
            }
        }
    }

    func handleTabState(_ gesture: UIPanGestureRecognizer) {
        let velocityY = gesture.velocity(in: gesture.view).y

        withAnimation {
            shouldShowSearch = !(velocityY < .zero)
        }
    }
}

extension ContactsView {
    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let contactsTextSize: CGFloat = 18
        static let plusImageHeight: CGFloat = 14
        static let plusImageWidth: CGFloat = 14
        static let headerPadding: CGFloat = 4
        static let userCellHeight: CGFloat = 70
        static let userCellPadding: CGFloat = 8
    }
}
