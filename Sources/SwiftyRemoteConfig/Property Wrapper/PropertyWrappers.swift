//
//  PropertyWrappers.swift
//  SwiftyRemoteConfig
//
//  Created by 伊藤史 on 2020/08/23.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

#if swift(>=5.1)
public struct SwiftyRemoteConfigOptions: OptionSet {
    public static let cached = SwiftyRemoteConfigOptions(rawValue: 1 << 0)
    public static let observed = SwiftyRemoteConfigOptions(rawValue: 1 << 2)

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

@propertyWrapper
public final class SwiftyRemoteConfig<T: RemoteConfigSerializable> where T.T == T {
    public let key: RemoteConfigKey<T>
    public let options: SwiftyRemoteConfigOptions

    public var wrappedValue: T {
        get {
            if options.contains(.cached) {
                return _value ?? RemoteConfigs[key]
            } else {
                return RemoteConfigs[key]
            }
        }
    }

    private var _value: T.T?
    private var observation: RemoteConfigDisposable?

    public init<KeyStore>(keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>, adapter: RemoteConfigAdapter<KeyStore>, options: SwiftyRemoteConfigOptions = []) {
        self.key = adapter.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            self.observation = adapter.observe(key) { [weak self] update in
                self?._value = update.newValue
            }
        }
    }

    public init(keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>, options: SwiftyRemoteConfigOptions = []) {
        self.key = RemoteConfigs.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            self.observation = RemoteConfigs.observe(key) { [weak self] update in
                self?._value = update.newValue
            }
        }
    }

    deinit {
        self.observation?.dispose()
    }
}
#endif
