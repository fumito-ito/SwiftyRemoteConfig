//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/23.
//

import Foundation
import Quick

final class RemoteConfigCustomSerializableSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = FrogCustomSerializable
    
    var defaultValue: Serializable = FrogCustomSerializable(name: "default")
    var keyStore = FrogKeyStore<Serializable>()
    
    override func spec() {
        given("CustomSerializable") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
