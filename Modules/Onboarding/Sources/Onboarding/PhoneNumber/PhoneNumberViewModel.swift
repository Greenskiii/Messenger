//
//  PhoneNumberViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Combine
import Foundation
import CommonLogic

final class PhoneNumberViewModel: ObservableObject {
    @Published var countryInfo: CountryInfo?
    @Published var phoneNumber: String = ""
    @Published var presentSheet: Bool = false
    @Published var searchCountry: String = ""
    let countryNumbersConfig: [CountryInfo]
    let onTapContinue: PassthroughSubject<String, Never>
    let onChangePhoneNumber = PassthroughSubject<String, Never>()
    private let phoneNumberFormatter = PhoneNumberFormatter.shared
    private var subscriptions = Set<AnyCancellable>()

    var filteredCountry: [CountryInfo] {
        if searchCountry.isEmpty {
            return countryNumbersConfig
        } else {
            return countryNumbersConfig.filter { $0.name.contains(searchCountry) }
        }
    }

    var fullPhoneNumber: String {
        guard let countryInfo = countryInfo else { return "" }
        return countryInfo.dialCode + phoneNumber.replacingOccurrences(of: " ", with: "")
    }

    init(
        countryNumbersConfig: [CountryInfo],
        onTapContinue: PassthroughSubject<String, Never>
    ) {
        self.countryNumbersConfig = countryNumbersConfig
        self.onTapContinue = onTapContinue
        self.countryInfo = countryNumbersConfig.first

        onChangePhoneNumber.sink { [weak self] phoneNumber in
            guard let self else { return }
            self.phoneNumber = phoneNumberFormatter.formatPhoneNumber(phoneNumber, withPattern: countryInfo?.pattern ?? "")
        }
        .store(in: &subscriptions)
    }
}
