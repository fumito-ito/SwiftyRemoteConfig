//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/23.
//

import Foundation
import Quick

final class RemoteConfigBestFroggiesEnumSerializableSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = BestFroggiesEnum
    
    var defaultValue: Serializable = .Dandy
    var keyStore = FrogKeyStore<Serializable>()
    
    override func spec() {
        given("Enum") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
