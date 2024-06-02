//
//  HomeView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI
import Kingfisher

struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        if let user = viewModel.user {
            Spacer()
            Text(user.phoneNumber ?? "")
            Text(user.name ?? "")

            KFImage(user.imageURL)
                .frame(width: 200, height: 200)
            
            Spacer()
            
            Button {
//                do {
//                    try Auth.auth().signOut()
//                } catch {
//                    print("Auth.auth().signOut() error")
//                }
            } label: {
                Text("Sign Out")
            }

        }
    }
}


#Preview {
    HomeView(
        viewModel: HomeViewModel(
            user: nil,
            onTapContinue: .init()
        )
    )
}
