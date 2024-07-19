//
//  UserCellView.swift
//
//
//  Created by Алексей Даневич on 11.07.2024.
//

import SwiftUI
import Kingfisher
import Design
import CommonLogic
import Combine

struct UserCellView: View {
    let user: User
    let secondaryInfo: String
    var shouldShowPlusButton: Bool = false
    var onTapPlusButton: PassthroughSubject<String, Never>? = nil

    var body: some View {
        VStack {
            HStack {
                ZStack(alignment: .topTrailing) {
                    userImage
                    if user.isOnline {
                        onlineStatus
                    }
                }
                userInfo
                Spacer()
                if shouldShowPlusButton {
                    plusButton
                }
            }
            .padding(.bottom, Constants.bottomPadding)
            Divider()
        }
    }

    var plusButton: some View {
        Button {
            onTapPlusButton?.send(user.id)
        } label: {
            Image(uiImage: Asset.Icons.plus.image)
                .resizable()
                .frame(
                    width: Constants.plusImageWidth,
                    height: Constants.plusImageHeight
                )
        }
    }

    var userImage: some View {
        ZStack {
            if !user.imageURL.isEmpty {
                KFImage(URL(string: user.imageURL))
                    .placeholder {
                        ProgressView()
                    }
                    .resizable(resizingMode: .stretch)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: Constants.imageCornerRadius
                        )
                    )
                    .frame(
                        width: Constants.imageWidth,
                        height: Constants.imageHeight
                    )
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: Constants.imageCornerRadius)
                        .foregroundStyle(Asset.Colors.blueIcon.swiftUIColor)
                        .frame(
                            width: Constants.imageWidth,
                            height: Constants.imageHeight
                        )
                    
                    Text(user.firstLetters)
                        .foregroundStyle(Color.white)
                }
            }
        }
    }

    var onlineStatus: some View {
        ZStack {
            Circle()
                .frame(width: Constants.circleWidth)
                .foregroundStyle(Color.green)
            Circle()
                .stroke(lineWidth: Constants.strokeCircleLineWidth)
                .frame(width: Constants.strokeCircleWidth)
                .foregroundStyle(Color.white)
        }
        .offset(
            x: Constants.isOnlineXOffset,
            y: Constants.isOnlineYOffset
        )
    }

    var userInfo: some View {
        VStack(alignment: .leading) {
            Text(user.name)
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.nameSize))
                .padding(.vertical, Constants.namePadding)
            Text(secondaryInfo)
                .font(FontFamily.Mulish.regular.swiftUIFont(size: Constants.lastSeenInfoSize))
                .foregroundStyle(Asset.Colors.disabled.swiftUIColor)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

extension UserCellView {
    enum Constants {
        static let bottomPadding: CGFloat = 12
        static let lastSeenInfoSize: CGFloat = 12
        static let nameSize: CGFloat = 14
        static let namePadding: CGFloat = 4
        static let isOnlineXOffset: CGFloat = 4
        static let isOnlineYOffset: CGFloat = -4
        static let strokeCircleLineWidth: CGFloat = 2
        static let strokeCircleWidth: CGFloat = 14
        static let circleWidth: CGFloat = 12
        static let imageCornerRadius: CGFloat = 16
        static let imageWidth: CGFloat = 48
        static let imageHeight: CGFloat = 48
        static let plusImageHeight: CGFloat = 14
        static let plusImageWidth: CGFloat = 14
    }
}
