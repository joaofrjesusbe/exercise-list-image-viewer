// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppDomains",
    platforms: [
        .iOS("16.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppImagesList",
            targets: ["AppImagesList"]
        ),
    ],
    dependencies: [
        .package(path: "../AppSDK/AppCore"),
        .package(path: "../AppSDK/DesignSystem"),
        .package(path: "../AppSDK/PixbayNetwork"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppImagesList",
            dependencies: ["DesignSystem", "PixbayNetwork", "AppCore"]
        ),
        .testTarget(
            name: "AppImagesListTests",
            dependencies: ["AppImagesList"]
        ),
    ]
)
