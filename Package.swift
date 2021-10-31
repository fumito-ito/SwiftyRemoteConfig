// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyRemoteConfig",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_12),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SwiftyRemoteConfig",
            targets: ["SwiftyRemoteConfig"]),
    ],
    dependencies: [
        .package(
            name: "Firebase",
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "8.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftyRemoteConfig",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "Firebase")
            ]),
        .testTarget(
            name: "SwiftyRemoteConfigTests",
            dependencies: ["SwiftyRemoteConfig"]),
    ]
)
