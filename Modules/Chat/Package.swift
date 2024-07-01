// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chat",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Chat",
            targets: ["Chat"]),
    ],
    dependencies: [
        .package(url: "https://github.com/QuickBirdEng/XCoordinator.git", from: "2.2.1"),
        .package(name: "BaseUI", path: "../BaseUI")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Chat",
            dependencies: [
                "XCoordinator",
                "BaseUI"
            ]
        ),
        .testTarget(
            name: "ChatTests",
            dependencies: ["Chat"]),
    ]
)
