// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "GamePaySDKCoreUI",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "GamePaySDKCoreUI",
            targets: ["GamePaySDKCoreUI"]),
    ],
    targets: [
        .target(
            name: "GamePaySDKCoreUI",
            dependencies: [],
            path: "GamePaySDKCoreUI/GamePaySDKCoreUI"
        )
    ],
    swiftLanguageModes: [.v5]
)
