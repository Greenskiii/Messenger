//
//  ProfileInfoView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI
import _PhotosUI_SwiftUI
import BaseUI
import Design

struct ProfileInfoView: View {
    @ObservedObject var viewModel: ProfileInfoViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constants.topSpacerHeight)
            profileImage
            profileInfo
            Spacer()
            button
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .background(Color(Asset.Colors.background.color))
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.avatarImage)
        }
    }

    private var button: some View {
        Button {
            viewModel.onTapSave.send()
        } label: {
            Text("Save")
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.buttonTextSize))
                .foregroundStyle(Color(Asset.Colors.offWhite.color))
                .frame(maxWidth: .infinity)
                .padding(.vertical, Constants.buttonTextPadding)
                .background {
                    Capsule()
                        .foregroundStyle(Color(Asset.Colors.button.color))
                        .padding(.horizontal, Constants.horizontalPadding)
                }
        }
    }

    private var profileInfo: some View {
        VStack {
            TextField(
                "First Name (Required)",
                text: $viewModel.firstName
            )
            .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.textFieldTextSize))
            .foregroundColor(Color(Asset.Colors.textField.color))
            .padding(Constants.textFieldPadding)
            .background{
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundStyle(Color(Asset.Colors.secondaryBackground.color))
            }
            .padding(.bottom, Constants.textFieldBottomPadding)
            
            TextField(
                "Last Name (Optional)",
                text: $viewModel.lastName
            )
            .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.textFieldTextSize))
            .foregroundColor(Color(Asset.Colors.textField.color))
            .padding(Constants.textFieldPadding)
            .background{
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundStyle(Color(Asset.Colors.secondaryBackground.color))
            }
        }
    }

    @ViewBuilder
    private var profileImage: some View {
        if let image = viewModel.avatarImage {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: image)
                    .resizable(resizingMode: .stretch)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
                    .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                    .padding(.bottom, Constants.imagePadding)
                    .onTapGesture {
                        viewModel.showingImagePicker = true
                    }
                
                Image(systemName: "minus.circle.fill")
                    .foregroundStyle(Color.red)
                    .frame(width: Constants.minusImageWidth, height: Constants.minusImageHeight)
                    .onTapGesture {
                        viewModel.avatarImage = nil
                    }
            }
        } else {
            Image(uiImage: Asset.Icons.profileImage.image)
                .resizable()
                .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                .padding(.bottom, Constants.imagePadding)
                .onTapGesture {
                    viewModel.showingImagePicker = true
                }
        }
    }
}

private extension ProfileInfoView {
    enum Constants {
        static let horizontalPadding: CGFloat = 24
        static let buttonTextPadding: CGFloat = 16
        static let buttonTextSize: CGFloat = 16
        static let cornerRadius: CGFloat = 4
        static let textFieldPadding: CGFloat = 6
        static let textFieldTextSize: CGFloat = 14
        static let textFieldBottomPadding: CGFloat = 12
        static let imageCornerRadius: CGFloat = 16
        static let imageHeight: CGFloat = 100
        static let imageWidth: CGFloat = 100
        static let imagePadding: CGFloat = 30
        static let minusImageHeight: CGFloat = 100
        static let minusImageWidth: CGFloat = 100
        static let topSpacerHeight: CGFloat = 130
    }
}

#Preview {
    ProfileInfoView(
        viewModel: ProfileInfoViewModel(
            onTapSave: .init()
        )
    )
}
