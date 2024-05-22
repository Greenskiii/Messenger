//
//  RemoteConfigManager.swift
//  webrtcProject
//
//  Created by Алексей Даневич on 22.05.2024.
//

import Firebase
import FirebaseRemoteConfig

protocol RemoteConfigManagerProtocol {
    func fetchConfig(completion: @escaping (Result<Void, Error>) -> Void)
    func getValue<T: Decodable>(forKey key: String, type: T.Type) -> T?
}

class RemoteConfigManager: RemoteConfigManagerProtocol {
    enum Keys {
        static let сountryNumbers = "сountryNumbers"
    }
    private var remoteConfig: RemoteConfig

    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 3600
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(loadLocalConfig())
    }

    func fetchConfig(completion: @escaping (Result<Void, Error>) -> Void) {
        remoteConfig.fetchAndActivate { status, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getValue<T: Decodable>(forKey key: String, type: T.Type) -> T? {
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
