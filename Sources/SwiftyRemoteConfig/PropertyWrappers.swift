//
//  PropertyWrappers.swift
//  
//
//  Created by 伊藤史 on 2022/01/07.
//

#if swift(>=5.1)
import FirebaseRemoteConfig

public struct SwiftyRemoteConfigOptions: OptionSet {
    public static let observed = SwiftyRemoteConfigOptions(rawValue: 1 << 0)
    public static let cached = SwiftyRemoteConfigOptions(rawValue: 1 << 2)

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
                return value ?? RemoteConfigs[key]
            } else {
                return RemoteConfigs[self.key]
            }
        }
        @available(*, unavailable, message: "SwiftyRemoteConfig's property wrapper does not support setting values yet.")
        set {
            fatalError("SwiftyRemoteConfig property wrapper does not support setting values yet.")
        }
    }

    private var value: T.T?
    private var observation: RemoteConfigDisposable?

    public init<KeyStore>(
        keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>,
        adapter: RemoteConfigAdapter<KeyStore>,
        options: SwiftyRemoteConfigOptions = []
    ) {
        self.key = adapter.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            observation = adapter.observe(key) { [weak self] update in
                self?.value = update.newValue
            }
        }
    }

    public init(
        keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>,
        options: SwiftyRemoteConfigOptions = []
    ) {
        self.key = RemoteConfigs.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            observation = RemoteConfigs.observe(key) { [weak self] update in
                self?.value = update.newValue
            }
        }
    }

    deinit {
        observation?.dispose()
    }
}
#endif
