//
//  AuthManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import FirebaseAuth

public protocol AuthManagerProtocol {
    var currentUser: User? { get }
    var phoneNumber: String { get }
    func verifyPhoneNumber(phoneNumber: String, completion: @escaping (_ success: Bool) -> Void)
    func signIn(verificationCode: String, completion: @escaping (_ success: Bool) -> Void)
}

public final class AuthManager: AuthManagerProtocol {
    public var currentUser: User? {
        Auth.auth().currentUser
    }
    private var phoneNumber1: String = ""
    private var currentVerificationId = ""

    public var phoneNumber: String {
        phoneNumber1
    }

    public init() {
        Auth.auth().languageCode = "en"
    }

    public func verifyPhoneNumber(phoneNumber: String, completion: @escaping (_ success: Bool) -> Void) {
        self.phoneNumber1 = phoneNumber
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.currentVerificationId = verificationID ?? ""
                completion(true)
            }
        }
    }

    public func signIn(verificationCode: String, completion: @escaping (_ success: Bool) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
