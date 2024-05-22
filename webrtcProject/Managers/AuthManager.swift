//
//  AuthManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import FirebaseAuth

protocol AuthManagerProtocol {
    var currentUser: User? { get }
    var phoneNumber: String { get }
    func verifyPhoneNumber(phoneNumber: String, completion: @escaping (_ success: Bool) -> Void)
    func signIn(verificationCode: String, completion: @escaping (_ success: Bool) -> Void)
}

final class AuthManager: AuthManagerProtocol {
    private(set) var currentUser: User?
    private(set) var phoneNumber: String = ""
    private var currentVerificationId = ""

    init() {
        Auth.auth().languageCode = "en"
    }

    func verifyPhoneNumber(phoneNumber: String, completion: @escaping (_ success: Bool) -> Void) {
        self.phoneNumber = phoneNumber
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

    func signIn(verificationCode: String, completion: @escaping (_ success: Bool) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: currentVerificationId, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.currentUser = Auth.auth().currentUser
                completion(true)
            }
        }
    }
}
