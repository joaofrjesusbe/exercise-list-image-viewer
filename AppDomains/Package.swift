// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppDomains",
    platforms: [
        .iOS("16.0"),
    ],
    products: [
        .library(
            name: "AppImagesList",
            targets: ["AppImagesList"]
        ),
    ],
    dependencies: [
        .package(path: "../AppSDK/AppCore"),
        .package(path: "../AppSDK/DesignSystem"),
        .package(path: "../AppSDK/PixbayNetwork"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3"),
    ],
    targets: [
        .target(
            name: "AppImagesList",
            dependencies: [
                "DesignSystem",
                "PixbayNetwork",
                "AppCore",
                .product(name: "FactoryKit", package: "Factory")
            ]
        ),
        .testTarget(
            name: "AppImagesListTests",
            dependencies: ["AppImagesList"]
        ),
    ]
)
