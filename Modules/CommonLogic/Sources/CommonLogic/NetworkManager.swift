//
//  NetworkManager.swift
//
//
//  Created by Алексей Даневич on 18.07.2024.
//

import Foundation
import Combine

public enum Endpoint {
    case addContact(currentUserId: String, userId: String)
    case getUserInfo(userId: String)
    case login(phoneNumber: String, name: String, imageURL: String?, id: String)
    case update(userId: String, name: String, imageURL: String?)
    case search(phoneNumber: String)
    case getContacts(ids: [String])

    var path: String {
        switch self {
        case let .addContact(currentUserId, _):
            return "/user/add/\(currentUserId)"
        case let .getUserInfo(userId):
            return "/find/\(userId)"
        case .login:
            return "/login"
        case let .update(userId, _, _):
            return "/user/update/\(userId)"
        case .search:
            return "/users/search"
        case .getContacts:
            return "/users"
        }
    }

    var httpMethod: String {
        switch self {
        case .getUserInfo, .search, .getContacts:
            return "GET"
        case .login, .addContact, .update:
            return "POST"
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .login, .addContact, .update, .getUserInfo:
            return []
        case .search(let phoneNumber):
            return [URLQueryItem(name: "phoneNumber", value: phoneNumber)]
        case let .getContacts(ids):
            return [URLQueryItem(name: "userIds", value: ids.joined(separator: ","))]
        }
    }

    var requestBody: Data? {
        var body: [String: Any]?
        switch self {
        case let .addContact(_, userId):
            body = [
                "userId": userId
            ]
        case let .login(phoneNumber, name, imageURL, id):
            body = [
                "userId": id,
                "name": name,
                "imageURL": imageURL ?? "",
                "phoneNumber": phoneNumber
            ]
        case let .update(_, name, imageURL):
            body = [
                "name": name,
                "imageURL": imageURL ?? ""
            ]
        case .search, .getContacts, .getUserInfo:
            body = nil
        }
        if let body {
            return try? JSONSerialization.data(withJSONObject: body, options: [])
        } else {
            return nil
        }
    }
}

public enum NetworkError: Error {
    case urlFailure
    case requestFailed(Error)
    case decodingFailed(Error)
}

final class NetworkManager {
    enum Constants {
        static let baseURL = "http://192.168.0.114:3000"
    }
    
    func execute<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = URL(string: "\(Constants.baseURL)\(endpoint.path)") else {
            return Fail(error: NetworkError.urlFailure).eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = endpoint.httpMethod
        request.httpBody = endpoint.requestBody
        request.url?.append(queryItems: endpoint.queryItems)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error in
                NetworkError.requestFailed(error)
            }
            .flatMap { data, response -> AnyPublisher<T, NetworkError> in
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    return Just(decodedData)
                        .setFailureType(to: NetworkError.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: NetworkError.decodingFailed(error)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
