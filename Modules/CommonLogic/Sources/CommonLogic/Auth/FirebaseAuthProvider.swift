//
//  FirebaseAuthProvider.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 04.06.2024.
//

import FirebaseAuth
import Combine

public protocol AuthProviderProtocol {
    var currentUser: FirebaseAuth.User? { get }
    var languageCode: String? { get set }
    func signIn(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func signOut() -> AnyPublisher<Void, Error>
}

public class FirebaseAuthProvider: AuthProviderProtocol {
    public var currentUser: FirebaseAuth.User? {
        Auth.auth().currentUser
    }

    public var languageCode: String? {
        get { Auth.auth().languageCode }
        set { Auth.auth().languageCode = newValue }
    }

    public init() { }

    public func signIn(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(with: credential, completion: completion)
    }

    public func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(NetworkError.urlFailure))
            }
        }.eraseToAnyPublisher()
    }
}
