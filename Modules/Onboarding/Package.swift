// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Onboarding",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Onboarding",
            targets: ["Onboarding"]),
    ],
    dependencies: [
        .package(name: "BaseUI", path: "../BaseUI"),
        .package(name: "CommonLogic", path: "../CommonLogic"),
        .package(name: "Design", path: "../Design"),
        .package(url: "https://github.com/QuickBirdEng/XCoordinator.git", from: "2.2.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Onboarding",
            dependencies: [
                "BaseUI",
                "CommonLogic",
                "Design",
                .product(name: "XCoordinator", package: "XCoordinator"),
            ]),
        .testTarget(
            name: "OnboardingTests",
            dependencies: ["Onboarding"]),
    ]
)
