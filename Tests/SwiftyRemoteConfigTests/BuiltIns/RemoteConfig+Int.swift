//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick

final class RemoteConfigIntSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = Int
    
    var defaultValue: Int = 1
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("Int") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
