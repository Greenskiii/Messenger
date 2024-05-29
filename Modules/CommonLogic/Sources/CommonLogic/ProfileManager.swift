//
//  ProfileManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 23.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

public protocol ProfileManagerProtocol {
    var currentUser: User? { get }
    func updateName(_ name: String, completion: @escaping (_ success: Bool) -> Void)
    func updateImage(userId: String, image: Data, completion: @escaping (_ success: Bool) -> Void)
    func updateUserInfo(userId: String, image: Data?, name: String, completion: @escaping (_ success: Bool) -> Void)
}

public final class ProfileManager: ProfileManagerProtocol {
    public var currentUser: User? {
        Auth.auth().currentUser
    }

    public init() { }

    public func updateUserInfo(
        userId: String,
        image: Data?,
        name: String,
        completion: @escaping (_ success: Bool) -> Void
    ) {
        let group = DispatchGroup()
        var updateSuccess = true

        group.enter()
        updateName(name) { success in
            if !success {
                updateSuccess = false
            }
            group.leave()
        }

        if let image {
            group.enter()
            updateImage(userId: userId, image: image) { success in
                if !success {
                    updateSuccess = false
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(updateSuccess)
        }
    }

    public func updateName(_ name: String, completion: @escaping (_ success: Bool) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name

        changeRequest?.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    public func updateImage(userId: String, image: Data, completion: @escaping (_ success: Bool) -> Void) {
        let storageReference = Storage.storage().reference().child(userId).child("Photo.jpeg")
        storageReference.putData(image) { (metadata, error) in
            if let error {
                print(error.localizedDescription)
                completion(false)
            }
            
            storageReference.downloadURL { (url, error) in
                if let url = url {
                    self.updateImagePath(imagePath: url.absoluteString) { success in
                        completion(success)
                    }
                } else {
                    print(error?.localizedDescription ?? "")
                    completion(false)
                }
            }
        }
    }

    private func updateImagePath(imagePath: String, completion: @escaping (_ success: Bool) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = URL(string: imagePath)

        changeRequest?.commitChanges { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
