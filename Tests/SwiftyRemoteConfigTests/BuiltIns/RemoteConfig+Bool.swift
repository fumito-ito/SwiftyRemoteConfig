//
//  RemoteConfig+Bool.swift
//  
//
//  Created by 伊藤史 on 2021/11/18.
//

import Foundation
import Quick

final class RemoteConfigBoolSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = Bool
    
    var defaultValue: Bool = true
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("Bool") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
