//
//  RemoteConfigCombine.swift
//  
//
//  Created by Fumito Ito on 2022/02/26.
//

import Foundation
import Combine
import FirebaseRemoteConfig

@available(iOS 13.0, macOS 10.15, *)
public extension RemoteConfig {
    /// An Combine accessor for RemoteConfig
    var combine: RemoteConfigCombine {
        return RemoteConfigCombine(self)
    }
}

/// An extension class with Combine.
///
/// It allows you handle RemoteConfig with Combine
@available(iOS 13.0, macOS 10.15, *)
public class RemoteConfigCombine {
    private let remoteConfig: RemoteConfig

    init(_ remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
    }
}

@available(iOS 13.0, macOS 10.15, *)
extension RemoteConfigCombine {
    class Subscription<S: Subscriber> {
        private(set) var subscriber: S?
        private(set) var cancellable: AnyCancellable?
        let remoteConfig: RemoteConfig

        init(subscriber: S, remoteConfig: RemoteConfig) {
            self.subscriber = subscriber
            self.remoteConfig = remoteConfig

            cancellable = remoteConfig.combine
                .fetchedPublisher()
                .sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] in self?.received() }
                )
        }

        func cancelSubscription() {
            cancellable?.cancel()
            subscriber = nil
        }

        func received() {
        }
    }

    final class RemoteConfigValueSubscription<S: Subscriber, T: RemoteConfigSerializable>: Subscription<S>, Combine.Subscription where S.Input == T.T, S.Failure == Never, T.T == T {
        private let key: RemoteConfigKey<T>

        init(subscriber: S, remoteConfig: RemoteConfig, key: RemoteConfigKey<T>) {
            self.key = key
            super.init(subscriber: subscriber, remoteConfig: remoteConfig)
        }

        public func request(_ demand: Subscribers.Demand) {}

        public func cancel() {
            super.cancelSubscription()
        }

        override func received() {
            _ = subscriber?.receive(remoteConfig[key])
        }
    }

    struct RemoteConfigValuePublisher<T: RemoteConfigSerializable>: Combine.Publisher where T.T == T {
        public typealias Output = T.T
        public typealias Failure = Never

        private let remoteConfig: RemoteConfig
        private let key: RemoteConfigKey<T>

        init(remoteConfig: RemoteConfig, key: RemoteConfigKey<T>) {
            self.remoteConfig = remoteConfig
            self.key = key
        }

        public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            subscriber.receive(subscription: RemoteConfigValueSubscription(
                subscriber: subscriber,
                remoteConfig: remoteConfig,
                key: key
            ))
        }
    }
}

@available(iOS 13.0, macOS 10.15, *)
public extension RemoteConfigCombine {
    /// Returns Publisher that tells you that RemoteConfig has fetched latest valeus from Backend.
    ///
    /// - Returns: A publisher `<Void, Never>`
    func fetchedPublisher() -> AnyPublisher<Void, Never> {
        return remoteConfig.publisher(for: \.lastFetchTime)
            .map({ _ in Void() })
            .eraseToAnyPublisher()
    }

    /// Returns Publisher that gives you a value matched a config key after fetching from RemoteConfig.
    ///
    /// - Parameters: keyPath: A keyPath for RemoteConfig key
    /// - Returns: A publisher `<T.T, Never>`
    func fetchedPublisher<T: RemoteConfigSerializable>(for keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>) -> AnyPublisher<T.T, Never> where T.T == T {
        return RemoteConfigValuePublisher(remoteConfig: remoteConfig, key: RemoteConfigs.keyStore[keyPath: keyPath]).eraseToAnyPublisher()
    }

    /// Returns Publisher that gives you a value matched a config key after fetching from RemoteConfig.
    ///
    /// - Parameters keyPath: A keyPath for RemoteConfig key
    /// - Parameters adapter: A RemoteConfig key adapeter for RemoteConfig keys
    /// - Returns: A publisher `<T.T, Never>`
    func fetchedPublisher<KeyStore, T: RemoteConfigSerializable>(for keyPath: KeyPath<KeyStore, RemoteConfigKey<T>>,
                                                                 adapter: RemoteConfigAdapter<KeyStore>) -> AnyPublisher<T.T, Never> where T.T == T {
        return RemoteConfigValuePublisher(remoteConfig: remoteConfig, key: adapter.keyStore[keyPath: keyPath]).eraseToAnyPublisher()
    }
}
