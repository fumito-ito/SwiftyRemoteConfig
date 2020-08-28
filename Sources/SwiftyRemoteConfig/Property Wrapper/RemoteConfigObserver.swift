//
//  RemoteConfigObserver.swift
//  SwiftyRemoteConfig
//
//  Created by 伊藤史 on 2020/08/23.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import Foundation
import FirebaseRemoteConfig

public protocol RemoteConfigDisposable {
    func dispose()
}

public final class RemoteConfigObserver<T: RemoteConfigSerializable>: NSObject, RemoteConfigDisposable where T == T.T {
    private let key: RemoteConfigKey<T>
    private let remoteConfig: RemoteConfig
    private let handler: ((Update) -> Void)
    private var didRemoveObserver: Bool = false

    init(key: RemoteConfigKey<T>, remoteConfig: RemoteConfig, options: NSKeyValueObservingOptions, handler: @escaping ((Update) -> Void)) {
        self.key = key
        self.remoteConfig = remoteConfig
        self.handler = handler

        super.init()

        remoteConfig.addObserver(self, forKeyPath: key._key, options: options, context: nil)
    }

    deinit {
        self.dispose()
    }

    public func dispose() {
        if self.didRemoveObserver {
            return
        }

        self.didRemoveObserver = true
        remoteConfig.removeObserver(self, forKeyPath: self.key._key, context: nil)
    }
}

extension RemoteConfigObserver {

    public struct Update {
        public let kind: NSKeyValueChange
        public let indexes: IndexSet?
        public let isPrior: Bool
        public let newValue: T.T?
        public let oldValue: T.T?

        init(changeSet: [NSKeyValueChangeKey: Any], key: RemoteConfigKey<T>) {
            self.kind = NSKeyValueChange(rawValue: changeSet[.kindKey] as! UInt)!
            self.indexes = changeSet[.indexesKey] as? IndexSet
            self.isPrior = changeSet[.notificationIsPriorKey] as? Bool ?? false
            self.oldValue = Update.deserialize(changeSet[.oldKey], for: key) ?? key.defaultValue
            self.newValue = Update.deserialize(changeSet[.newKey], for: key) ?? key.defaultValue
        }

        private static func deserialize<T: RemoteConfigSerializable>(_ value: Any?, for key: RemoteConfigKey<T>) -> T.T? where T.T == T {
            guard let value = value as? RemoteConfigValue else {
                return nil
            }

            let deserialized = T._remoteConfig.deserialize(value)

            if key.isOptional,
                let deserialized = deserialized,
                let _deserialized = deserialized as? OptionalTypeCheck,
                _deserialized.isNil == false {

                return _deserialized as? T.T
            } else if key.isOptional == false, let deserialized = deserialized {

                return deserialized
            } else {

                return value as? T.T
            }
        }
    }
}
