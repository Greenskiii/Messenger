//
//  RemoteConfigManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import Combine
import FirebaseRemoteConfig

public protocol RemoteConfigManagerProtocol {
    func fetchConfig() -> AnyPublisher<Void, Error>
    func getValue<T: Decodable>(forKey key: String, type: T.Type) -> T?
}

public class RemoteConfigManager: RemoteConfigManagerProtocol {
    public enum Keys {
        public static let сountryNumbers = "сountryNumbers"
    }
    private var remoteConfig: RemoteConfig

    public init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(loadLocalConfig())
    }

    public func fetchConfig() -> AnyPublisher<Void, Error> {
         return Future<Void, Error> { promise in
             self.remoteConfig.fetchAndActivate { status, error in
                 if let error = error {
                     promise(.failure(error))
                 } else {
                     promise(.success(()))
                 }
             }
         }
         .eraseToAnyPublisher()
     }

    public func getValue<T: Decodable>(forKey key: String, type: T.Type) -> T? {
        guard let jsonString = remoteConfig.configValue(forKey: key).stringValue,
              let data = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }

    private func loadLocalConfig() -> [String: NSObject] {
        if let path = Bundle.main.path(forResource: "local_config", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: NSObject] {
            return jsonObject
        } else {
            print("Failed to load local config")
            return [:]
        }
    }
}
