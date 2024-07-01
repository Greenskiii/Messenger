//
//  AuthManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

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

    private let firebasePhoneAuthProvider: PhoneAuthProviderProtocol
    private var firebaseAuthProvider: AuthProviderProtocol

    public var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }

    public var phoneNumberPublisher: AnyPublisher<String, Never> {
        $phoneNumber.eraseToAnyPublisher()
    }

    public init(
        firebasePhoneAuthProvider: PhoneAuthProviderProtocol = FirebasePhoneAuthProvider(),
        firebaseAuthProvider: AuthProviderProtocol = FirebaseAuthProvider()
    ) {
        self.firebasePhoneAuthProvider = firebasePhoneAuthProvider
        self.firebaseAuthProvider = firebaseAuthProvider
        self.firebaseAuthProvider.languageCode = "en"
        let user = firebaseAuthProvider.currentUser
        self.currentUser = firebaseAuthProvider.convertUser(user)
    }

    public func verifyPhoneNumber(phoneNumber: String) -> AnyPublisher<Void, Error> {
        self.phoneNumber = phoneNumber
        return Future<Void, Error> { [weak self] promise in
            self?.firebasePhoneAuthProvider.verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    self?.currentVerificationId = verificationID ?? ""
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func signIn(verificationCode: String) -> AnyPublisher<Void, Error> {
        let credential = firebasePhoneAuthProvider.credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        return Future<Void, Error> { [weak self] promise in
            self?.firebaseAuthProvider.signIn(with: credential) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    self?.currentUser = self?.firebaseAuthProvider.convertUser(authResult?.user)
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
