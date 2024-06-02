//
//  CodeField.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import SwiftUI
import Design

struct CodeField: View {
    let maxDigits: Int
    @Binding var code: String
    @State var isDisabled = false

    var body: some View {
        VStack() {
            ZStack {
                pinDots
                backgroundField
            }
        }
    }
    
    private var pinDots: some View {
        HStack {
            Spacer()
            ForEach(0..<maxDigits, id: \.self) { index in
                if code.count <= index {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(Color(uiColor: Asset.Colors.neutralLine.color))
                        .frame(width: Constants.imageWidth, height: Constants.imageHeight)
                } else {
                    Text(code.getCharacter(at: index))
                        .font(FontFamily.Mulish.bold.swiftUIFont(size: Constants.textSize))
                }
                Spacer()
            }
        }
    }
    
    private var backgroundField: some View {
        return TextField("", text: $code)
           .accentColor(.clear)
           .foregroundColor(.clear)
           .keyboardType(.numberPad)
           .disabled(isDisabled)
           .onChange(of: code) { newValue in
               if newValue.count > maxDigits {
                   code = String(newValue.prefix(maxDigits))
               }
           }
    }
}

private extension CodeField {
    enum Constants {
        static let imageWidth: CGFloat = 24
        static let imageHeight: CGFloat = 24
        static let textSize: CGFloat = 32
    }
}

fileprivate extension String {
    func getCharacter(at index: Int) -> String {
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        return String(self[stringIndex])
    }
}
