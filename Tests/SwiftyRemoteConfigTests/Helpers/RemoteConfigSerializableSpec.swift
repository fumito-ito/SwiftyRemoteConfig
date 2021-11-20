//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/06.
//

import Foundation
import Quick
import Nimble
@testable import SwiftyRemoteConfig
import FirebaseRemoteConfig
import FirebaseCore

protocol RemoteConfigSerializableSpec {
    associatedtype Serializable: RemoteConfigSerializable & Equatable

    var defaultValue: Serializable.T { get }
    var keyStore: FrogKeyStore<Serializable> { get }
}

extension RemoteConfigSerializableSpec where Serializable.T: Equatable, Serializable.T == Serializable, Serializable.ArrayBridge.T == [Serializable.T] {

    func setupFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure(options: FrogFirebaseConfig.firebaseOptions)
        }
    }
    
    func testValues() {
        when("key-default value") {
            var config: RemoteConfigAdapter<FrogKeyStore<Serializable>>!
            
            beforeEach {
                let remoteConfig = RemoteConfig.remoteConfig()
                config = RemoteConfigAdapter(remoteConfig: remoteConfig,
                                                   keyStore: self.keyStore)
            }
            
            then("create a key") {
                let key = RemoteConfigKey<Serializable>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }
            
            then("create an array key") {
                let key = RemoteConfigKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }
            
            then("get a default value") {
                let key = RemoteConfigKey<Serializable>("test", defaultValue: self.defaultValue)
                expect(config[key]) == self.defaultValue
            }
            
            #if swift(>=5.1)
            then("get a default value with dynamicMemberLookup") {
                self.keyStore.testValue = RemoteConfigKey<Serializable>("test", defaultValue: self.defaultValue)
                expect(config.testValue) == self.defaultValue
            }
            #endif
            
            then("get a default array value") {
                let key = RemoteConfigKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                expect(config[key]) == [self.defaultValue]
            }
            
            #if swift(>=5.1)
            then("get a default array value with dynamicMemberLookup") {
                self.keyStore.testArray = RemoteConfigKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                expect(config.testArray) == [self.defaultValue]
            }
            #endif
        }
    }
    
    func testOptionalValues() {
        
        when("key-default optional value") {
            var config: RemoteConfigAdapter<FrogKeyStore<Serializable>>!
            
            beforeEach {
                let remoteConfig = RemoteConfig.remoteConfig()
                config = RemoteConfigAdapter(remoteConfig: remoteConfig,
                                                   keyStore: self.keyStore)
            }
            
            then("create a key") {
                let key = RemoteConfigKey<Serializable?>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }
            
            then("create an array key") {
                let key = RemoteConfigKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }
            
            then("get a default value") {
                let key = RemoteConfigKey<Serializable?>("test", defaultValue: self.defaultValue)
                expect(config[key]) == self.defaultValue
            }
            
            #if swift(>=5.1)
            then("get a default value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = RemoteConfigKey<Serializable?>("test", defaultValue: self.defaultValue)
                expect(config.testOptionalValue) == self.defaultValue
            }
            #endif
            
            then("get a default array value") {
                let key = RemoteConfigKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                expect(config[key]) == [self.defaultValue]
            }
            
            #if swift(>=5.1)
            then("get a default array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = RemoteConfigKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                expect(config.testOptionalArray) == [self.defaultValue]
            }
            #endif
        }
    }
    
    func testOptionalValuesWithoutDefaultValue() {
            
        when("key-nil optional value") {
            var config: RemoteConfigAdapter<FrogKeyStore<Serializable>>!
            
            beforeEach {
                let remoteConfig = RemoteConfig.remoteConfig()
                config = RemoteConfigAdapter(remoteConfig: remoteConfig,
                                                   keyStore: self.keyStore)
            }
            
            then("create a key") {
                let key = RemoteConfigKey<Serializable?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }
            
            then("create an array key") {
                let key = RemoteConfigKey<[Serializable]?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("compare optional value to non-optional value") {
                let key = RemoteConfigKey<Serializable?>("test")
                expect(config[key] == nil).to(beTrue())
                expect(config[key] != self.defaultValue).to(beTrue())
            }
            
            #if swift(>=5.1)
            then("compare optional value to non-optional value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = RemoteConfigKey<Serializable?>("test")
                expect(config.testOptionalValue == nil).to(beTrue())
                expect(config.testOptionalValue != self.defaultValue).to(beTrue())
            }
            #endif
        }
    }
}
