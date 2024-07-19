//
//  UserStatusManager.swift
//
//
//  Created by Алексей Даневич on 13.07.2024.
//

import Foundation
import Combine

class ContactsManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private let userId: String
    private let userName: String
    private var subscribedUserIds = [String]()
    private var cancellables = Set<AnyCancellable>()
    private let urlSession: URLSession
    @Published private var users: [User] = []
    var usersPublisher: AnyPublisher<[User], Never> {
        $users.eraseToAnyPublisher()
    }

    init(userId: String, userName: String, urlSession: URLSession = .shared) {
        self.userId = userId
        self.userName = userName
        self.urlSession = urlSession
        connectWebSocket()
    }

    func setUsers(_ users: [User]) {
        self.users = users
        self.subscribeToUpdates(userIds: users.map(\.id))
    }

    private func connectWebSocket() {
        guard let url = URL(string: "ws://192.168.0.114:8080") else { return }
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        sendLoginMessage()
        receiveMessages()
    }

    func subscribeToUpdates(userIds: [String]) {
        subscribedUserIds = userIds
        sendMessage(type: "subscribe", data: ["userIds": userIds])
    }

    private func sendLoginMessage() {
        sendMessage(type: "login", data: ["userId": userId, "name": userName])
    }

    private func sendMessage(type: String, data: [String: Any]) {
        var message = data
        message["type"] = type
        if let jsonData = try? JSONSerialization.data(withJSONObject: message, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            let wsMessage = URLSessionWebSocketTask.Message.string(jsonString)
            webSocketTask?.send(wsMessage) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        }
    }

    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleWebSocketMessage(text)
                default:
                    break
                }
            }
            self?.receiveMessages()
        }
    }

    private func handleWebSocketMessage(_ text: String) {
        if let data = text.data(using: .utf8), let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let type = json["type"] as? String, type == "statusUpdate" {
                if let id = json["userId"] as? String,
                   let status = json["status"] as? String,
                   let index = users.firstIndex(where: { $0.id == id }) {
                    self.users[index].status = status
                }
            }
        }
    }
}
