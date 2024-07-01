//
//  FirebasePhoneAuthProviderStub.swift
//  
//
//  Created by Алексей Даневич on 04.06.2024.
//

import FirebaseAuth
@testable import CommonLogic

final class FirebasePhoneAuthProviderStub: PhoneAuthProviderProtocol {
    var verificationResult: Result<String, Error>?

     func verifyPhoneNumber(_ phoneNumber: String, uiDelegate: AuthUIDelegate?, completion: @escaping (String?, Error?) -> Void) {
         switch verificationResult {
         case .success(let verificationID):
             completion(verificationID, nil)
         case .failure(let error):
             completion(nil, error)
         case .none:
             completion(nil, NSError(domain: "MockPhoneAuthProvider", code: -1, userInfo: nil))
         }
     }

     func credential(withVerificationID verificationID: String, verificationCode: String) -> AuthCredential {
         return PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
     }
}
