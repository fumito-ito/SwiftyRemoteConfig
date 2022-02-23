//
//  RemoteConfigKeys+Extension.swift
//  Example
//
//  Created by Fumito Ito on 2022/02/23.
//

import Foundation
import SwiftyRemoteConfig

extension RemoteConfigKeys {
    var contentText: RemoteConfigKey<String> { .init("content_text", defaultValue: "Hello, World!!") }
}
