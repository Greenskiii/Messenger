//
//  PhoneNumberView.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import SwiftUI
import Combine

struct PhoneNumberView: View {
    @ObservedObject var viewModel: PhoneNumberViewModel
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: Constants.topSpacerHeight)
            infoView
            countryInfoView
            Spacer()
            continueButton
        }
        .background(Color.background)
        .sheet(isPresented: $viewModel.presentSheet) {
            sheetView
        }
    }
    
    private var infoView: some View {
        VStack {
            Text("Enter Your Phone Number")
                .font(FontFamily.Mulish.bold.swiftUIFont(size: Constants.titleTextSize))
                .padding(.bottom, Constants.bottomPadding)
            
            Text("Please confirm your country code and enter\n your phone number")
                .font(FontFamily.Mulish.regular.swiftUIFont(size: Constants.secondaryTextSize))
                .multilineTextAlignment(.center)
                .padding(.bottom, Constants.secondaryTextPadding)
        }
    }
    
    @ViewBuilder
    private var countryInfoView: some View {
        if let countryInfo = viewModel.countryInfo {
            HStack(spacing: Constants.countryInfoSpacing) {
                Text("\(countryInfo.flag) \(countryInfo.dialCode)")
                    .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.countryInfoTextSize))
                    .foregroundColor(Color.textField)
                    .padding(Constants.countryInfoPadding)
                    .background {
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .foregroundStyle(Color.secondaryBackground)
                    }
                    .onTapGesture {
                        viewModel.presentSheet = true
                    }
                
                TextField("Phone Number", text: $viewModel.phoneNumber)
                    .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.countryInfoTextSize))
                    .foregroundColor(Color.textField)
                    .padding(Constants.countryInfoPadding)
                    .keyboardType(.numberPad)
                    .background{
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .foregroundStyle(Color.secondaryBackground)
                    }
                    .onChange(of: viewModel.phoneNumber) { newValue in
                        viewModel.phoneNumber = viewModel.formatPhoneNumber(newValue, withPattern: countryInfo.pattern)
                    }
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }
    
    private var continueButton: some View {
        Button {
            viewModel.onTapContinue.send(viewModel.fullPhoneNumber)
        } label: {
            Text("Continue")
                .font(FontFamily.Mulish.semiBold.swiftUIFont(size: Constants.continueButtonTextSize))
                .foregroundStyle(.offWhite)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Constants.continueButtonPadding)
                .background {
                    Capsule()
                        .foregroundStyle(.button)
                        .padding(.horizontal, Constants.horizontalPadding)
                }
        }
        .padding(.bottom, Constants.bottomPadding)
    }
    
    private var sheetView: some View {
        NavigationView {
            List(viewModel.filteredCountry) { country in
                HStack {
                    Text(country.flag)
                    Text(country.name)
                        .font(.headline)
                    Spacer()
                    Text(country.dialCode)
                        .foregroundColor(.secondary)
                }
                .onTapGesture {
                    viewModel.countryInfo = country
                    viewModel.presentSheet = false
                    viewModel.searchCountry = ""
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchCountry, prompt: "Your country")
        }
        .presentationDetents([.medium, .large])
    }
}

private extension PhoneNumberView {
    enum Constants {
        static let bottomPadding: CGFloat = 8
        static let continueButtonPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 24
        static let continueButtonTextSize: CGFloat = 16
        static let countryInfoTextSize: CGFloat = 14
        static let countryInfoPadding: CGFloat = 6
        static let countryInfoSpacing: CGFloat = 8
        static let cornerRadius: CGFloat = 4
        static let titleTextSize: CGFloat = 24
        static let topSpacerHeight: CGFloat = 160
        static let secondaryTextSize: CGFloat = 14
        static let secondaryTextPadding: CGFloat = 48
    }
}

#Preview {
    PhoneNumberView(
        viewModel: PhoneNumberViewModel(
            countryNumbersConfig: [
                CountryInfo(
                    flag: "🇺🇦",
                    code: "UA",
                    pattern: "+380 ## ### ## ##",
                    dialCode: "+380",
                    name: "Ukraine"
                ),
                CountryInfo(
                    flag: "🇩🇪",
                    code: "DE",
                    pattern: "+49 (##) ### ## ##",
                    dialCode: "+49",
                    name: "Germany"
                )
            ],
            onTapContinue: .init()
        )
    )
}
