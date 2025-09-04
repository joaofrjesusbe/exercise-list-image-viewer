// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "AppDomains",
    defaultLocalization: "en",
    platforms: [
        .iOS("17.0"),
    ],
    products: [
        .library(
            name: "AppImagesList",
            targets: ["AppImagesList"]
        ),
        .library(
            name: "AppMain",
            targets: ["AppMain"]
        )
    ],
    dependencies: [
        .package(path: "../AppSDK/AppCore"),
        .package(path: "../AppSDK/DesignSystem"),
        .package(path: "../AppSDK/PixbayNetwork"),
        .package(url: "https://github.com/hmlongco/Factory", from: "2.5.3"),
    ],
    targets: [
        .target(
            name: "AppMain",
            dependencies: [
                "DesignSystem",
                "AppCore",
                "AppImagesList"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "AppImagesList",
            dependencies: [
                "DesignSystem",
                "PixbayNetwork",
                "AppCore",
                .product(name: "FactoryKit", package: "Factory")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "AppImagesListTests",
            dependencies: ["AppImagesList"]
        ),
    ]
)
