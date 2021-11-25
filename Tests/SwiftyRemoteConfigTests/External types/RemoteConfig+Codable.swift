//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/23.
//

import Foundation
import Quick
import SwiftyRemoteConfig

final class RemoteConfigCodableSpec: QuickSpec, RemoteConfigSerializableSpec {
    
    typealias Serializable = FrogCodable
    
    var defaultValue: Serializable = FrogCodable(name: "default")
    var keyStore = FrogKeyStore<Serializable>()

    override func spec() {
        given("Codable") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
