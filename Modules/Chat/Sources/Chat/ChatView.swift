//
//  ChatView.swift
//  webrtc
//
//  Created by Алексей Даневич on 15.05.2024.
//

import SwiftUI

struct ChatView: View {
    let viewModel: ChatViewModel

    var body: some View {
        Text("Chat")
    }
}


#Preview {
    ChatView(
        viewModel: ChatViewModel(onTapContinue: .init())
    )
}
