//
//  RemoteConfig+Observing.swift
//  SwiftyRemoteConfig
//
//  Created by 伊藤史 on 2020/08/23.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

public extension RemoteConfigAdapter {

    func observe<T: RemoteConfigSerializable>(_ key: RemoteConfigKey<T>,
                                              options: NSKeyValueObservingOptions = [.new, .old],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return self.remoteConfig.observe(key, options: options, handler: handler)
    }

    func observe<T: RemoteConfigSerializable>(_ keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>,
                                              options: NSKeyValueObservingOptions = [.new, .old],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return self.remoteConfig.observe(self.keyStore[keyPath: keyPath],
                                         options: options,
                                         handler: handler)
    }
}

public extension RemoteConfig {
    func observe<T: RemoteConfigSerializable>(_ key: RemoteConfigKey<T>,
                                              options: NSKeyValueObservingOptions = [.old, .new],
                                              handler: @escaping (RemoteConfigObserver<T>.Update) -> Void) -> RemoteConfigDisposable {
        return RemoteConfigObserver(key: key, remoteConfig: self, options: options, handler: handler)
    }
}
