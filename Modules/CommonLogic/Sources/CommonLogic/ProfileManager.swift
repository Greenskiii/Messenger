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
    var userId: String? { get }
    func registerUser(name: String, image: Data?) -> AnyPublisher<Void, Error>
    func getUsers(with phoneNumber: String) -> AnyPublisher<[User], NetworkError>
    func addContact(with id: String) -> AnyPublisher<Void, Error>
    func getUserInfo()
}

public final class ProfileManager: ProfileManagerProtocol {
    private let networkManager = NetworkManager()
    private let firebaseAuthProvider: FirebaseAuthProvider
    private var contactsManager: ContactsManager?
    private var user: User?
    @Published private var currentUserRelay = PassthroughSubject<User?, Never>()

    public var currentUserPublisher: AnyPublisher<User?, Never> {
        currentUserRelay.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public var userId: String? {
        firebaseAuthProvider.currentUser?.uid
    }
    
    private var phoneNumber: String? {
        firebaseAuthProvider.currentUser?.phoneNumber
    }
    
    public init(firebaseAuthProvider: FirebaseAuthProvider = FirebaseAuthProvider()) {
        self.firebaseAuthProvider = firebaseAuthProvider
        self.getUserInfo()
    }

    public func getUserInfo() {
        guard let userId else { return }
        
        networkManager.execute(endpoint: .getUserInfo(userId: userId))
            .sink { _ in
            } receiveValue: { [weak self] user in
                self?.getContacts(for: user)
            }
            .store(in: &cancellables)
    }

    public func addContact(with id: String) -> AnyPublisher<Void, Error> {
        guard let currentUserId = userId else {
            return Fail(error: NetworkError.urlFailure).eraseToAnyPublisher()
        }
        return networkManager.execute(endpoint: .addContact(currentUserId: currentUserId, userId: id))
            .map { [weak self] (user: User) in
                if !(self?.user?.contacts?.contains(where: { $0.id == user.id }) ?? true) {
                    var contacts = self?.user?.contacts
                    contacts?.append(user)
                    self?.contactsManager?.setUsers(contacts ?? [])
                }
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    public func getUsers(with phoneNumber: String) -> AnyPublisher<[User], NetworkError> {
        networkManager.execute(endpoint: .search(phoneNumber: phoneNumber))
    }

    public func registerUser(name: String, image: Data?) -> AnyPublisher<Void, Error> {
        guard let userId, let phoneNumber else {
            return Fail(error: NetworkError.urlFailure).eraseToAnyPublisher()
        }
        
        if let image {
            return addUserInfoWithImage(userId: userId, name: name, image: image, phoneNumber: phoneNumber)
        } else {
            return addUserInfo(userId: userId, name: name, imageURL: nil, phoneNumber: phoneNumber)
        }
    }
}

private extension ProfileManager {
    func getContacts(for user: User) {
        networkManager.execute(endpoint: .getContacts(ids: user.friends))
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    self?.currentUserRelay.send(user)
                    self?.contactsManager = ContactsManager(userId: user.id, userName: user.name)
                }
            } receiveValue: { [weak self] (users: [User]) in
                var updatedUser = user
                updatedUser.contacts = users
                self?.user = updatedUser
                self?.currentUserRelay.send(updatedUser)
                self?.contactsManager = ContactsManager(userId: user.id, userName: user.name)
                self?.setUpBindings()
                self?.contactsManager?.setUsers(users)
            }
            .store(in: &cancellables)
    }

    func addUserInfo(userId: String, name: String, imageURL: String?, phoneNumber: String) -> AnyPublisher<Void, Error> {
        return networkManager.execute(endpoint: Endpoint.login(phoneNumber: phoneNumber, name: name, imageURL: imageURL, id: userId))
            .map { [weak self] (user: User) in
                self?.currentUserRelay.send(user)
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func addUserInfoWithImage(userId: String, name: String, image: Data, phoneNumber: String) -> AnyPublisher<Void, Error> {
        let storageReference = Storage.storage().reference().child(userId).child("Photo.jpeg")
        
        return uploadImage(storageReference: storageReference, image: image)
            .flatMap { url in
                self.addUserInfo(userId: userId, name: name, imageURL: url.absoluteString, phoneNumber: phoneNumber)
            }
            .eraseToAnyPublisher()
    }

    func uploadImage(storageReference: StorageReference, image: Data) -> AnyPublisher<URL, Error> {
        Future<URL, Error> { promise in
            storageReference.putData(image, metadata: nil) { metadata, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                storageReference.downloadURL { url, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let url = url {
                        promise(.success(url))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func setUpBindings() {
        self.contactsManager?.usersPublisher
            .sink { [weak self] users in
                var updatedUser = self?.user
                updatedUser?.contacts = users
                self?.currentUserRelay.send(updatedUser)
            }
            .store(in: &self.cancellables)
    }
}
