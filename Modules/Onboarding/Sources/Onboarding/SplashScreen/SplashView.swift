//
//  SplashView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI
import Design

struct SplashView: View {
    let viewModel: SplashViewModel

    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constants.spacerHeight)
            title
            Spacer()
            button
        }
        .background(Color(Asset.Colors.background.color))
    }

    private var title: some View {
        VStack {
            Image(uiImage: Asset.Icons.splashImage.image)
                .resizable()
                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                .padding(.bottom, Constants.imagePadding)

            Text("Connect easily with\n your family and friends\n over countries")
                .font(FontFamily.Mulish.bold.swiftUIFont(size: Constants.textFontSize))
                .multilineTextAlignment(.center)
        }
    }

    private var button: some View {
        Button {
            viewModel.onTapContinue.send()
        } label: {
            Text("Start Messaging")
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.buttonFontSize))
                .foregroundStyle(Color(Asset.Colors.offWhite.color))
                .frame(maxWidth: .infinity)
                .padding(.vertical, Constants.buttonTextPadding)
                .background {
                    Capsule()
                        .foregroundStyle(Color(Asset.Colors.button.color))
                        .padding(.horizontal, Constants.buttonPadding)
                }
        }
    }
}

private extension SplashView {
    enum Constants {
        static let spacerHeight: CGFloat = 120
        static let imageHeight: CGFloat = 271
        static let imageWidth: CGFloat = 262
        static let imagePadding: CGFloat = 40
        static let textFontSize: CGFloat = 24
        static let buttonFontSize: CGFloat = 16
        static let buttonTextPadding: CGFloat = 16
        static let buttonPadding: CGFloat = 16
    }
}

#Preview {
    SplashView(
        viewModel: SplashViewModel(
            onTapContinue: .init()
        )
    )
}
