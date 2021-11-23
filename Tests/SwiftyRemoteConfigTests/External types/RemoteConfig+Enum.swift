//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/23.
//

import Foundation
import Quick
import SwiftyRemoteConfig

enum BestFroggiesEnum: String, RemoteConfigSerializable {
    case Andy
    case Dandy
}

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
