// swift-tools-version: 6.3.3

// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-time-to-live-dependencies open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-time-to-live-dependencies project authors
// Licensed under Apache License 2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "swift-time-to-live-dependencies",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Time To Live Dependencies",
            targets: ["Time To Live Dependencies"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-time-to-live.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-clocks-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Time To Live Dependencies",
            dependencies: [
                .product(name: "Time To Live", package: "swift-time-to-live"),
                .product(name: "Clocks Dependencies", package: "swift-clocks-dependencies"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]
        ),
        .testTarget(
            name: "Time To Live Dependencies Tests",
            dependencies: [
                "Time To Live Dependencies",
                .product(name: "Dependencies Test Support", package: "swift-dependencies"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem
}
