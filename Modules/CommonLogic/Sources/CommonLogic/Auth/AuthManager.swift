//
//  AuthManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import Combine

public protocol AuthManagerProtocol {
    var isLoggedIn: Bool { get }
    var phoneNumberPublisher: AnyPublisher<String, Never> { get }
    func verifyPhoneNumber(phoneNumber: String) -> AnyPublisher<Void, Error>
    func signIn(verificationCode: String) -> AnyPublisher<String?, Error>
}

public final class AuthManager: AuthManagerProtocol {
    @Published private var phoneNumber: String = ""
    private var currentVerificationId = ""

    private let firebasePhoneAuthProvider: PhoneAuthProviderProtocol
    private var firebaseAuthProvider: AuthProviderProtocol

    public var isLoggedIn: Bool {
        firebaseAuthProvider.currentUser != nil
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

    public func signIn(verificationCode: String) -> AnyPublisher<String?, Error> {
        let credential = firebasePhoneAuthProvider.credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        return Future<String?, Error> { [weak self] promise in
            self?.firebaseAuthProvider.signIn(with: credential) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success((authResult?.user.displayName)))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
