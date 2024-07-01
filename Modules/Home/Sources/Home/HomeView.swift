//
//  HomeView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI

struct HomeView: View {
    let viewModel: HomeViewModel

    var body: some View {
        Text("Home")
    }
}


#Preview {
    HomeView(
        viewModel: HomeViewModel(
            onTapContinue: .init()
        )
    )
}
