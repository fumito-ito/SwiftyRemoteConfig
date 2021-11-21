//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick

final class RemoteConfigDoubleSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = Double
    
    var defaultValue: Double = 1.0
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("Double") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
