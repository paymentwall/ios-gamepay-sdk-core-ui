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
    dependencies: []
)
