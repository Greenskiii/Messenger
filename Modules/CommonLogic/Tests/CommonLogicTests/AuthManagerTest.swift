//
//  AuthManagerTest.swift
//  
//
//  Created by Алексей Даневич on 04.06.2024.
//

import XCTest
import Combine
import Firebase
@testable import CommonLogic

final class AuthManagerTest: XCTestCase {
    var authManager: AuthManager!
    var firebaseAuthProvider: FirebaseAuthProviderStub!
    var firebasePhoneAuthProvider: FirebasePhoneAuthProviderStub!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        firebaseAuthProvider = FirebaseAuthProviderStub()
        firebasePhoneAuthProvider = FirebasePhoneAuthProviderStub()
        authManager = AuthManager(
            firebasePhoneAuthProvider: firebasePhoneAuthProvider,
            firebaseAuthProvider: firebaseAuthProvider
        )
        cancellables = []
    }

    override func tearDown() {
        authManager = nil
        firebaseAuthProvider = nil
        firebasePhoneAuthProvider = nil
        cancellables = nil
        super.tearDown()
    }

    func testVerifyPhoneNumberSuccess() {
        let phoneNumber = "1234567890"
        firebasePhoneAuthProvider.verificationResult = .success("verificationID")
        
        let expectation = self.expectation(description: "VerifyPhoneNumber")

        authManager.verifyPhoneNumber(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed but failed")
                }
            }, receiveValue: { })
            .store(in: &cancellables)
        
        authManager.phoneNumberPublisher
            .sink { receivedPhoneNumber in
                XCTAssertEqual(receivedPhoneNumber, phoneNumber)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testVerifyPhoneNumberFailure() {
        let phoneNumber = "1234567890"
        let expectedError = NSError(domain: "Test", code: -1, userInfo: nil)
        firebasePhoneAuthProvider.verificationResult = .failure(expectedError)
        
        let expectation = self.expectation(description: "VerifyPhoneNumber")

        authManager.verifyPhoneNumber(phoneNumber: phoneNumber)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as NSError, expectedError)
                    expectation.fulfill()
                }
            }, receiveValue: {
                XCTFail("Expected to fail but succeeded")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

//    func testSignInSuccess() {
//        let verificationCode = "123456"
//        firebasePhoneAuthProvider.verificationResult = .success("verificationID")
//        firebaseAuthProvider.signInResult = .success(nil)
//        
//        // Simulate successful verification to set currentVerificationId
//        _ = authManager.verifyPhoneNumber(phoneNumber: "1234567890").sink(receiveCompletion: { _ in }, receiveValue: { })
//
//        let expectation = self.expectation(description: "SignIn")
//
//        authManager.currentUserPublisher
//            .dropFirst()
//            .sink { user in
//                XCTAssertNotNil(user)
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//
//        authManager.signIn(verificationCode: verificationCode)
//            .sink(receiveCompletion: { completion in
//                if case .failure = completion {
//                    XCTFail("Expected to succeed but failed")
//                }
//            }, receiveValue: { })
//            .store(in: &cancellables)
//
//        waitForExpectations(timeout: 5.0, handler: nil)
//    }
//
//    func testSignInFailure() {
//        let verificationCode = "123456"
//        let expectedError = NSError(domain: "Test", code: -1, userInfo: nil)
//        firebasePhoneAuthProvider.verificationResult = .success("verificationID")
//        firebaseAuthProvider.signInResult = .failure(expectedError)
//
//        _ = authManager.verifyPhoneNumber(phoneNumber: "1234567890").sink(receiveCompletion: { _ in }, receiveValue: { })
//
//        let expectation = self.expectation(description: "SignIn")
//
//        authManager.signIn(verificationCode: verificationCode)
//            .sink(receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    XCTAssertEqual(error as NSError, expectedError)
//                    expectation.fulfill()
//                }
//            }, receiveValue: {
//                XCTFail("Expected to fail but succeeded")
//            })
//            .store(in: &cancellables)
//
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
}
