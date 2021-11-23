//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/23.
//

import Foundation
import Quick

final class RemoteConfigFrogSerializableSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = FrogSerializable
    
    var defaultValue: FrogSerializable = FrogSerializable(name: "default")
    var keyStore = FrogKeyStore<FrogSerializable>()
    
    override func spec() {
        given("Serializable") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
