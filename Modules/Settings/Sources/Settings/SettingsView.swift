//
//  SettingsView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI

struct SettingsView: View {
    let viewModel: SettingsViewModel

    var body: some View {
        Text("Settings")
    }
}


#Preview {
    SettingsView(viewModel: SettingsViewModel(onTapContinue: .init()))
}
