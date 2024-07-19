// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Contacts",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Contacts",
            targets: ["Contacts"]
        ),
    ],
    dependencies: [
        .package(name: "BaseUI", path: "../BaseUI"),
        .package(name: "CommonLogic", path: "../CommonLogic"),
        .package(name: "Messages", path: "../Messages"),
        .package(url: "https://github.com/QuickBirdEng/XCoordinator.git", from: "2.2.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.11.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Contacts",
            dependencies: [
                "BaseUI",
                "CommonLogic",
                "Kingfisher",
                "XCoordinator",
                "Messages"
            ]
        ),
        .testTarget(
            name: "ContactsTests",
            dependencies: ["Contacts"]
        ),
    ]
)
