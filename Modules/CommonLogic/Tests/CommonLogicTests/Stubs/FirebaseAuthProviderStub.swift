//
//  FirebaseAuthProviderStub.swift
//
//
//  Created by Алексей Даневич on 04.06.2024.
//

import Foundation
import FirebaseAuth
import Firebase
@testable import CommonLogic

final class FirebaseAuthProviderStub: AuthProviderProtocol {
    var currentUser: FirebaseAuth.User?
    var languageCode: String?

    var signInResult: Result<AuthDataResult?, Error>?

    init(currentUser: FirebaseAuth.User? = nil, languageCode: String? = nil, signInResult: Result<AuthDataResult?, Error>? = nil) {
        self.currentUser = currentUser
        self.languageCode = languageCode
        self.signInResult = signInResult
    }

    func signIn(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        switch signInResult {
        case .success(let result):
            completion(result, nil)
        case .failure(let error):
            completion(nil, error)
        case .none:
            completion(nil, NSError(domain: "MockAuthProvider", code: -1, userInfo: nil))
        }
    }
    
    func convertUser(_ user: FirebaseAuth.User?) -> CommonLogic.User? {
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
