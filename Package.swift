// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import class Foundation.ProcessInfo

let shouldTest = true //ProcessInfo.processInfo.environment["TEST"] == "1"

func resolveDependencies() -> [Package.Dependency] {
    let firebaseRemoteConfig: Package.Dependency = .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.0.0"))
    guard shouldTest else { return [firebaseRemoteConfig] }

    return [
        firebaseRemoteConfig,
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "2.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.0")),
    ]
}

func resolveTargets() -> [Target] {
    let baseTarget = Target.target(
        name: "SwiftyRemoteConfig",
        dependencies: [
            .product(name: "FirebaseRemoteConfig", package: "Firebase")
        ],
        path: "Sources")
    let testTarget = Target.testTarget(
        name: "SwiftyRemoteConfigTests",
        dependencies: ["SwiftyRemoteConfig", "Quick", "Nimble"])

    return shouldTest ? [baseTarget, testTarget] : [baseTarget]
}

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
    dependencies: resolveDependencies(),
    targets: resolveTargets()
)
