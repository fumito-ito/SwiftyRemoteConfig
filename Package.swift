// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyRemoteConfig",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
        .tvOS(.v12),
        .watchOS(.v6),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyRemoteConfig",
            targets: ["SwiftyRemoteConfig"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.0.0")
        ),
    ],
    targets: [
        .target(
            name: "SwiftyRemoteConfig",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "SwiftyRemoteConfigTests",
            dependencies: [
                "SwiftyRemoteConfig"
            ],
            path: "Tests"
        ),
    ]
)
