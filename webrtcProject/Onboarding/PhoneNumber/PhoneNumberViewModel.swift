//
//  PhoneNumberViewModel.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 21.05.2024.
//

import Combine
import Foundation

final class PhoneNumberViewModel: ObservableObject {
    @Published var countryInfo: CountryInfo?
    @Published var phoneNumber: String = ""
    @Published var presentSheet: Bool = false
    @Published var searchCountry: String = ""
    let countryNumbersConfig: [CountryInfo]
    let onTapContinue: PassthroughSubject<String, Never>

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
    }

    func formatPhoneNumber(_ number: String, withPattern pattern: String) -> String {
        let cleanNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        var result = ""
        var startIndex = cleanNumber.startIndex
        let endIndex = cleanNumber.endIndex
        
        for char in pattern where startIndex < endIndex {
            if char == "#" {
                result.append(cleanNumber[startIndex])
                startIndex = cleanNumber.index(after: startIndex)
            } else {
                result.append(char)
            }
        }
        
        return result
    }

}
