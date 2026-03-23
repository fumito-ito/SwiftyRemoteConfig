//
//  RemoteConfig.swift
//  SwiftyRemoteConfig
//
//  Created by 伊藤史 on 2020/08/13.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

public var RemoteConfigs = RemoteConfigAdapter<RemoteConfigKeys>(remoteConfig: RemoteConfig.remoteConfig(), keyStore: .init())

public extension RemoteConfig {
    var allKeysAndValues: [String: RemoteConfigValue] {
        var keys = Set<String>()
        keys.formUnion(allKeys(from: .default))
        keys.formUnion(allKeys(from: .remote))
        keys.formUnion(allKeys(from: .static))

        return keys.reduce(into: [String: RemoteConfigValue]()) { result, key in
            result[key] = self[key]
        }
    }
    
    func hasKey<T: RemoteConfigSerializable>(_ key: RemoteConfigKey<T>) -> Bool {
        self.configValue(forKey: key._key).stringValue.isEmpty == false
    }
    
    func setupListening() {
        addOnConfigUpdateListener { [weak self] update, error in
            guard error == nil else { return }
            
            self?.activate { [weak self] success, _ in
                guard success else { return }
                
                for i in update?.updatedKeys ?? [] {
                    self?.willChangeValue(forKey: i)
                    self?.didChangeValue(forKey: i)
                }
            }
        }

        let oldData = self.allKeysAndValues

        fetchAndActivate { [weak self] status, error in
            guard error == nil else { return }
            guard let self else { return }
            let newData = self.allKeysAndValues
            
            for i in newData {
                guard oldData[i.key] != i.value else { continue }
                self.willChangeValue(forKey: i.key)
                self.didChangeValue(forKey: i.key)
            }
        }
    }
}
