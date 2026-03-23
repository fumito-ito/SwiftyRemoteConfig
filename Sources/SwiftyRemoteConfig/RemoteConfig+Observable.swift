//
//  RemoteConfig+Observable.swift
//  SwiftyRemoteConfig
//
//  Created by Ivan Kh on 23.03.2026.
//

import Firebase
import Combine
import SwiftUI

@MainActor @propertyWrapper
public struct RemoteConfigObservable<T: RemoteConfigSerializable>: DynamicProperty where T.T == T {
    @StateObject private var observable: ObservableValue
    
    public var wrappedValue: T.T {
        observable.value
    }
    
    public var projectedValue: Binding<T.T> {
        Binding(
            get: { observable.value },
            set: { observable.value = $0 }
        )
    }
    
    public init(_ keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>) {
        _observable = StateObject(wrappedValue: ObservableValue(keyPath))
    }
    
    @MainActor private final class ObservableValue: ObservableObject {
        @Published var value: T.T
        private var bag: Set<AnyCancellable> = []
        
        init(_ keyPath: KeyPath<RemoteConfigKeys, RemoteConfigKey<T>>) {
            value = RemoteConfigs[keyPath]
            
            RemoteConfig.remoteConfig()
                .combine
                .fetchedPublisher(for: keyPath)
                .receive(on: RunLoop.main)
                .assign(to: \.value, on: self)
                .store(in: &bag)
        }
    }
}
