//
//  FirebasePhoneAuthProvider.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 04.06.2024.
//

import FirebaseAuth

public protocol PhoneAuthProviderProtocol {
    func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void)
    func credential(withVerificationID verificationID: String, verificationCode: String) -> AuthCredential
}

public final class FirebasePhoneAuthProvider: PhoneAuthProviderProtocol {
let phoneAuthProvider = PhoneAuthProvider.provider()
    public init() { }

    public func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void) {
        phoneAuthProvider.verifyPhoneNumber(phoneNumber, uiDelegate: uiDelegate, completion: completion)
    }

    public func credential(withVerificationID verificationID: String, verificationCode: String) -> AuthCredential {
        return phoneAuthProvider.credential(withVerificationID: verificationID, verificationCode: verificationCode)
    }
}
