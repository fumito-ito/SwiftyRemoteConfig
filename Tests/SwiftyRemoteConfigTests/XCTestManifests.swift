//
//  XCTestManifests.swift
//  SwiftyRemoteConfigTests
//
//  Created by 伊藤史 on 2020/08/19.
//  Copyright © 2020 Fumito Ito. All rights reserved.
//

import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(SwiftyRemoteConfigTests.allTests),
    ]
}
#endif
