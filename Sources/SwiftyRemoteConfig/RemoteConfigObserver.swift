//
//  RemoteConfigObserver.swift
//  
//
//  Created by Fumito Ito on 2022/02/23.
//

import Foundation
import Firebase

public protocol RemoteConfigDisposable {
    func dispose()
}

public final class RemoteConfigObserver<T: RemoteConfigSerializable>: NSObject, RemoteConfigDisposable where T == T.T {
    public struct Update {
        public let kind: NSKeyValueChange
        public let isPrior: Bool
        public let newValue: T.T?
        public let oldValue: T.T?

        init(dict: [NSKeyValueChangeKey: Any], key: RemoteConfigKey<T>) {
            kind = NSKeyValueChange(rawValue: dict[.kindKey] as! UInt)!
            isPrior = dict[.notificationIsPriorKey] as? Bool ?? false
            if let oldConfigValue = dict[.oldKey] as? RemoteConfigValue {
                oldValue = Self.deserialize(oldConfigValue, for: key)
            } else {
                oldValue = key.defaultValue
            }

            if let newConfigValue = dict[.newKey] as? RemoteConfigValue {
                newValue = Self.deserialize(newConfigValue, for: key)
            } else {
                newValue = key.defaultValue
            }
        }

        private static func deserialize(_ value: RemoteConfigValue?, for key: RemoteConfigKey<T>) -> T.T? where T.T == T {
            guard let value = value else {
                return nil
            }

            let deserialized = T._remoteConfig.deserialize(value)

            if key.isOptional {
                return deserialized
            } else {
                assert(deserialized != nil, "non-optional RemoteConfigValue should be unwrapped")
                return deserialized!
            }
        }
    }

    private let key: RemoteConfigKey<T>
    private let remoteConfig: RemoteConfig
    private let handler: ((Update) -> Void)
    private var didRemoteObserver: Bool = false
    private let observeKeyPathName: String
    private var oldValue: T.T?

    init(key: RemoteConfigKey<T>, remoteConfig: RemoteConfig, options: NSKeyValueObservingOptions, handler: @escaping ((Update) -> Void)) {
        self.key = key
        self.remoteConfig = remoteConfig
        self.handler = handler
        self.observeKeyPathName = #keyPath(RemoteConfig.lastFetchTime)
        self.oldValue = remoteConfig[key]
        super.init()

        remoteConfig.addObserver(self, forKeyPath: observeKeyPathName, options: options, context: nil)
    }

    deinit {
        dispose()
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == observeKeyPathName else {
            return
        }

        var dictionary = change
        dictionary.removeValue(forKey: .newKey)
        dictionary.removeValue(forKey: .oldKey)
        let values: [NSKeyValueChangeKey : Any] = [
            NSKeyValueChangeKey.newKey: remoteConfig[key],
            NSKeyValueChangeKey.oldKey: oldValue as Any
        ]
        dictionary.merge(values, uniquingKeysWith: { (l, r) in l })

        let update = Update(dict: change, key: key)
        handler(update)

        oldValue = remoteConfig[key]
    }

    public func dispose() {
        if didRemoteObserver { return }

        didRemoteObserver = true
        remoteConfig.removeObserver(self, forKeyPath: observeKeyPathName, context: nil)
    }
}
