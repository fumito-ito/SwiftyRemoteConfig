//
//  PropertyWrappers.swift
//  
//
//  Created by 伊藤史 on 2022/01/07.
//

#if swift(>=5.1)
@propertyWrapper
public final class SwiftyRemoteConfig<T: RemoteConfigSerializable> where T.T == T {

    public let key: RemoteConfigKey<T>

    public var wrappedValue: T {
        get {
            return RemoteConfigs[self.key]
        }
    }

    public init<KeyStore>(
        keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>,
        adapter: RemoteConfigAdapter<KeyStore>
    ) {
        self.key = adapter.keyStore[keyPath: keyPath]
    }

    public init(
        keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>
    ) {
        self.key = RemoteConfigs.keyStore[keyPath: keyPath]
    }
}
#endif
