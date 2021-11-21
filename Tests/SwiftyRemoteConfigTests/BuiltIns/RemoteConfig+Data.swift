//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick

final class RemoteConfigDataSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = Data
    
    var defaultValue: Data = Data()
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("Data") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
