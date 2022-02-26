//
//  RemoteConfig+Observing.swift
//  
//
//  Created by Fumito Ito on 2022/02/24.
//

import Foundation
import FirebaseRemoteConfig

public extension RemoteConfigAdapter {
    func observe<T: RemoteConfigSerializable>(_ key: RemoteConfigKey<T>,
                                              options: NSKeyValueObservingOptions = [.new, .old],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return remoteConfig.observe(key, options: options, handler: handler)
    }

    func observe<T: RemoteConfigSerializable>(_ keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>,
                                              options: NSKeyValueObservingOptions = [.new, .old],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return remoteConfig.observe(keyStore[keyPath: keyPath], options: options, handler: handler)
    }
}

public extension RemoteConfig {
    func observe<T: RemoteConfigSerializable>(_ key: RemoteConfigKey<T>,
                                              options: NSKeyValueObservingOptions = [.new, .old],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return RemoteConfigObserver(key: key, remoteConfig: self, options: options, handler: handler)
    }
}
