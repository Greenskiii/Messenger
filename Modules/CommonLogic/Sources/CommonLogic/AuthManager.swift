//
//  AuthManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import FirebaseAuth
import Combine

public protocol AuthManagerProtocol {
    var currentUserPublisher: AnyPublisher<User?, Never> { get }
    var phoneNumberPublisher: AnyPublisher<String, Never> { get }
    func verifyPhoneNumber(phoneNumber: String) -> AnyPublisher<Void, Error>
    func signIn(verificationCode: String) -> AnyPublisher<Void, Error>
}

public final class AuthManager: AuthManagerProtocol {
    @Published private var currentUser: User? = nil
    @Published private var phoneNumber: String = ""
    private var currentVerificationId = ""

    public var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }

    public var phoneNumberPublisher: AnyPublisher<String, Never> {
        $phoneNumber.eraseToAnyPublisher()
    }

    public init() {
        Auth.auth().languageCode = "en"
    }

    public func verifyPhoneNumber(phoneNumber: String) -> AnyPublisher<Void, Error> {
        self.phoneNumber = phoneNumber
        return Future<Void, Error> { promise in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    self.currentVerificationId = verificationID ?? ""
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func signIn(verificationCode: String) -> AnyPublisher<Void, Error> {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        return Future<Void, Error> { promise in
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    self.currentUser = self.setUser(authResult?.user)
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func setUser(_ user: FirebaseAuth.User?) -> User? {
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
