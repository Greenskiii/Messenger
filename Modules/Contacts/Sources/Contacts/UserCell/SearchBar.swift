//
//  SearchBar.swift
//
//
//  Created by Алексей Даневич on 19.07.2024.
//

import SwiftUI
import Design

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: .zero) {
            Image(uiImage: Asset.Icons.magnifying.image)
                .resizable()
                .frame(
                    width: Constants.magnifyingImageWidth,
                    height: Constants.magnifyingImageHeight
                )
                .padding(.horizontal, Constants.magnifyingImagePadding)

            TextField("Search", text: $text)
        }
        .padding(.vertical, Constants.searchBarPadding)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .background {
            RoundedRectangle(cornerRadius: Constants.searchBarCornerRadius)
                .foregroundStyle(Color(Asset.Colors.searchBackground.color))
        }
        .padding(.vertical, Constants.searchBarMainPadding)
        .transition(
            .asymmetric(
                insertion: .push(from: .top),
                removal: .push(from: .bottom)
            )
        )
    }
}
extension SearchBar {
    enum Constants {
        static let magnifyingImageHeight: CGFloat = 16
        static let magnifyingImageWidth: CGFloat = 16
        static let magnifyingImagePadding: CGFloat = 8
        static let searchBarPadding: CGFloat = 8
        static let searchBarCornerRadius: CGFloat = 4
        static let searchBarMainPadding: CGFloat = 16
    }
}
