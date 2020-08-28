//
//  RemoteConfigKeys+Extensions.swift
//  SwiftyRemoteConfigExample
//
//  Created by 伊藤史 on 2020/08/26.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import Foundation
import SwiftyRemoteConfig

extension RemoteConfigKeys {
    var contentText: RemoteConfigKey<String> { .init("content_text", defaultValue: "Hello, World!!") }
}
