//
//  MessagesView.swift
//
//
//  Created by Алексей Даневич on 26.07.2024.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject var viewModel: MessagesViewModel
    
    let currentUser = "User1"
    @State var text = ""
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("User2")
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(maxWidth: geometry.size.height)
                        ForEach(messages, id: \.self) { message in
                            HStack {
                                if currentUser == message.userName {
                                    Spacer()
                                }
                                VStack {
                                    Text(message.text)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("\(message.date.description)")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .background {
                                    RoundedRectangle(cornerRadius: 6)
                                        .foregroundStyle(.gray)
                                }
                                .frame(maxWidth: geometry.size.width * 0.6)
                                .padding()
                                if currentUser != message.userName {
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
                HStack {
                    TextField("type", text: $text)
                        .textFieldStyle(.roundedBorder)
                    Button {
                        
                    } label: {
                        Text("Send")
                    }
                }
                .padding()
            }
        }
    }
}
extension MessagesView {
    var messages: [Message] {
        [
            Message(
                date: Date(),
                text: "123",
                userName: "User1"
            ),
            Message(
                date: Date(),
                text: "321",
                userName: "User2"
            )
        ]
    }
    
    
    struct Message: Hashable {
        let date: Date
        let text: String
        let userName: String
    }
}

//#Preview {
//    MessagesView()
//}
