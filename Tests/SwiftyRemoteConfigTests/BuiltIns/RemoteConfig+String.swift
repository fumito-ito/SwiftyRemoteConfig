//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick

final class RemoteConfigStringSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = String
    
    var defaultValue: String = "Firebase"
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("String") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
