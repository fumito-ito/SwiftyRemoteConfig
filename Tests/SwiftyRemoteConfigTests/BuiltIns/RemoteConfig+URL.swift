//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick

final class RemoteConfigURLSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = URL
    
    var defaultValue: URL = URL(string: "https://console.firebase.google.com/")!
    var keyStore = FrogKeyStore<Serializable>()
    
    required init() {}
    
    override func spec() {
        given("URL") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
