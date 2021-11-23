//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/11/21.
//

import Foundation
import Quick
import SwiftyRemoteConfig

#if canImport(UIKit) || canImport(AppKit)
#if canImport(UIKit)
    import UIKit.UIColor
    public typealias Color = UIColor
#elseif canImport(AppKit)
    import AppKit.NSColor
    public typealias Color = NSColor
#endif

extension Color: RemoteConfigSerializable {}

final class RemoteConfigColorSerializableSpec: QuickSpec, RemoteConfigSerializableSpec {
    typealias Serializable = Color
    
    var defaultValue: Color = .blue
    var keyStore = FrogKeyStore<Serializable>()
    
    override func spec() {
        given("Color") {
            self.setupFirebase()
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
#endif
