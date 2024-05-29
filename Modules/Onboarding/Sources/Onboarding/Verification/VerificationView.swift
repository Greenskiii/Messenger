//
//  VerificationView.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import SwiftUI
import Design

struct VerificationView: View {
    @ObservedObject var viewModel: VerificationViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constants.topSpacerHeight)
            infoView
            codeView
            Spacer()
            resendButtonView
        }
        .padding(.bottom, Constants.bottomPadding)
        .background(Color(Asset.Colors.background.color))
    }

    private var resendButtonView: some View {
        Button {
            viewModel.onTapResendButton.send()
        } label: {
            Text("Resend Code")
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.buttonTextSize))
                .foregroundStyle(Color(Asset.Colors.secondaryText.color))
        }
    }

    private var codeView: some View {
        CodeField(
            maxDigits: Constants.maxDigits,
            code: $viewModel.code
        )
        .frame(height: Constants.codeFieldHeight)
        .onChange(of: viewModel.code) { code in
            if code.count == Constants.maxDigits {
                viewModel.onSendCode.send(code)
            }
        }
    }

    private var infoView: some View {
        VStack {
            Text("Enter Code")
                .font(FontFamily.Mulish.bold.swiftUIFont(size: Constants.titleTextSize))
                .padding(.bottom, Constants.bottomPadding)

            Text("We have sent you an SMS with the code\n to \(viewModel.phoneNumber)")
                .font(FontFamily.Mulish.regular.swiftUIFont(size: Constants.secondaryTextSize))
                .multilineTextAlignment(.center)
                .padding(.bottom, Constants.secondaryTextPadding)
        }
    }
}

private extension VerificationView {
    enum Constants {
        static let bottomPadding: CGFloat = 8
        static let buttonTextSize: CGFloat = 16
        static let codeFieldHeight: CGFloat = 32
        static let maxDigits = 6
        static let secondaryTextPadding: CGFloat = 48
        static let secondaryTextSize: CGFloat = 14
        static let titleTextSize: CGFloat = 24
        static let topSpacerHeight: CGFloat = 160
    }
}

#Preview {
    VerificationView(
        viewModel: VerificationViewModel(
            phoneNumber: "+380 95 959 95 95",
            onSendCode: .init(),
            onTapResendButton: .init()
        )
    )
}
