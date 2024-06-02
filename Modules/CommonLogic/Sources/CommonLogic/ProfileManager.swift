//
//  ProfileManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 23.05.2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import Combine

public protocol ProfileManagerProtocol {
    var currentUserPublisher: AnyPublisher<User?, Never> { get }
    func updateName(_ name: String) -> AnyPublisher<Void, Error>
    func updateImage(userId: String, image: Data) -> AnyPublisher<Void, Error>
    func updateUserInfo(image: Data?, name: String) -> AnyPublisher<Void, Error>
}

public final class ProfileManager: ProfileManagerProtocol {
    @Published private var currentUser: User?

    public var currentUserPublisher: AnyPublisher<User?, Never> {
        $currentUser.eraseToAnyPublisher()
    }

    private var cancellables = Set<AnyCancellable>()

    public init(currentUser: AnyPublisher<User?, Never>) {
        currentUser
            .assign(to: &$currentUser)
    }

    public func updateUserInfo(image: Data?, name: String) -> AnyPublisher<Void, Error> {
        guard let user = currentUser else {
            return Fail(error: NSError()).eraseToAnyPublisher()
        }
        var publishers: [AnyPublisher<Void, Error>] = []

        publishers.append(updateName(name))
        
        if let image = image {
            publishers.append(updateImage(userId: user.id, image: image))
        }

        return Publishers.MergeMany(publishers)
            .collect()
            .map { _ in }
            .eraseToAnyPublisher()
    }

    public func updateName(_ name: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name

            changeRequest?.commitChanges { error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    public func updateImage(userId: String, image: Data) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let storageReference = Storage.storage().reference().child(userId).child("Photo.jpeg")
            storageReference.putData(image, metadata: nil) { metadata, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(error))
                    return
                }
                
                self.fetchDownloadURL(storageReference: storageReference)
                    .flatMap { url in
                        self.updateImagePath(imagePath: url.absoluteString)
                    }
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                        }
                    }, receiveValue: { })
                    .store(in: &self.cancellables)
            }
        }
        .eraseToAnyPublisher()
    }

    private func fetchDownloadURL(storageReference: StorageReference) -> AnyPublisher<URL, Error> {
        Future<URL, Error> { promise in
            storageReference.downloadURL { url, error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(error))
                } else if let url = url {
                    promise(.success(url))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func updateImagePath(imagePath: String) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.photoURL = URL(string: imagePath)

            changeRequest?.commitChanges { error in
                if let error = error {
                    print(error.localizedDescription)
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
