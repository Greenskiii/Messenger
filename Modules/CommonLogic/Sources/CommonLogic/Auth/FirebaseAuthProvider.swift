//
//  FirebaseAuthProvider.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 04.06.2024.
//

import FirebaseAuth

public protocol AuthProviderProtocol {
    var currentUser: FirebaseAuth.User? { get }
    var languageCode: String? { get set }
    func signIn(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void)
    func convertUser(_ user: FirebaseAuth.User?) -> User?
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

    public func convertUser(_ user: FirebaseAuth.User?) -> User? {
        guard let user else {
            return nil
        }
        return User(
            name: user.displayName,
            imageURL: user.photoURL,
            phoneNumber: user.phoneNumber,
            id: user.uid
        )
    }
}
