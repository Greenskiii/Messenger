//
//  SplashView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI

struct SplashView: View {
    let viewModel: SplashViewModel

    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constants.spacerHeight)
            Image(uiImage: Asset.Icons.splashImage.image)
                .resizable()
                .frame(width: 262, height: 271)
                .padding(.bottom, 40)
            
            Text("Connect easily with\n your family and friends\n over countries")
                .font(FontFamily.Mulish.bold.swiftUIFont(size: 24))
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                viewModel.onTapContinue.send()
            } label: {
                Text("Start Messaging")
                    .font(FontFamily.Mulish.semiBold.swiftUIFont(size: 16))
                    .foregroundStyle(.offWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        Capsule()
                            .foregroundStyle(.button)
                            .padding(.horizontal, 24)
                    }
            }
        }
        .background(Color.background)
    }
}

private extension SplashView {
    enum Constants {
        static let spacerHeight: CGFloat = 120
        enum Font {
        }
    }
}

#Preview {
    SplashView(
        viewModel: SplashViewModel(
            onTapContinue: .init()
        )
    )
}
